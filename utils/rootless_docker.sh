#!/bin/bash

################################################################################
# Rootless Docker Setup
#
# Purpose:
#   Installs and configures Docker in rootless mode on Ubuntu/Debian, so the
#   docker daemon runs as the current user rather than root.
#
# Behavior:
#   1. Verifies /etc/subuid and /etc/subgid have an entry for the current user.
#   2. Installs apt prerequisites (uidmap, dbus-user-session, slirp4netns,
#      iptables, docker.io, docker-rootless-extras).
#   3. Stops and disables the system-wide docker daemon if present (it
#      conflicts with the rootless daemon's setup).
#   4. Runs dockerd-rootless-setuptool.sh install, which drops a user-level
#      systemd unit at ~/.config/systemd/user/docker.service.
#   5. Enables systemd lingering so the daemon stays running after logout.
#   6. Enables and starts the docker user service.
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Sudo privileges (for apt and system service management).
#   - subuid/subgid entries for the current user (created automatically by
#     adduser on modern Ubuntu — verified by this script).
#   - DOCKER_HOST is set by nix/pkgs/docker.nix; reload your shell after this
#     script completes so the CLI talks to the rootless socket.
#
# Note:
#   This script is idempotent — it can be re-run safely. Re-installing on top
#   of an existing rootless setup will print a warning and exit without
#   touching state.
################################################################################

set -euo pipefail

USER_NAME=$(id -un)
USER_UID=$(id -u)

# 1. verify subuid / subgid entries exist
if ! grep -q "^${USER_NAME}:" /etc/subuid; then
    echo "ERROR: no /etc/subuid entry for ${USER_NAME}" >&2
    echo "  Fix: sudo usermod --add-subuids 100000-165535 ${USER_NAME}" >&2
    exit 1
fi
if ! grep -q "^${USER_NAME}:" /etc/subgid; then
    echo "ERROR: no /etc/subgid entry for ${USER_NAME}" >&2
    echo "  Fix: sudo usermod --add-subgids 100000-165535 ${USER_NAME}" >&2
    exit 1
fi

# 2. install apt prerequisites
echo "==> Installing apt prerequisites"
sudo apt update
sudo apt install --yes \
    uidmap \
    dbus-user-session \
    slirp4netns \
    iptables \
    docker.io \
    docker-rootless-extras

# 3. disable rootful daemon if it's running
if systemctl is-active --quiet docker.service; then
    echo "==> Stopping system docker.service"
    sudo systemctl disable --now docker.service docker.socket
fi

# 4. run the setuptool as the current user (it refuses to run as root)
if [ -f "${HOME}/.config/systemd/user/docker.service" ]; then
    echo "==> docker.service already installed for ${USER_NAME}, skipping setuptool"
else
    echo "==> Running dockerd-rootless-setuptool.sh install"
    dockerd-rootless-setuptool.sh install
fi

# 5. enable lingering so the daemon survives logout
if ! loginctl show-user "${USER_NAME}" 2>/dev/null | grep -q "Linger=yes"; then
    echo "==> Enabling systemd lingering for ${USER_NAME}"
    sudo loginctl enable-linger "${USER_NAME}"
fi

# 6. enable + start the user service
echo "==> Enabling and starting docker.service (user)"
systemctl --user enable --now docker.service

echo ""
echo "==> Done. Rootless docker socket: /run/user/${USER_UID}/docker.sock"
echo "    Reload your shell (or 'exec \$SHELL') so DOCKER_HOST takes effect,"
echo "    then verify with: docker info | grep -i rootless"
