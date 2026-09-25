#!/bin/bash

################################################################################
# Rootless Docker Setup
#
# Purpose:
#   Configures Docker in rootless mode on Ubuntu/Debian, so the docker daemon
#   runs as the current user. A container escape then lands in this user
#   account instead of root.
#
# Usage:
#   ./rootless_docker.sh              install rootless docker
#   ./rootless_docker.sh --dry-run    print every action, change nothing
#   ./rootless_docker.sh --uninstall  revert to the rootful daemon
#
# Behavior:
#   0. Exits early if podman is installed, because podman is already rootless.
#   1. Exits with an error if apt-get is absent, as every install step is apt.
#   2. Verifies the shell has a systemd user session.
#   3. Verifies /etc/subuid and /etc/subgid have an entry for the current user.
#   4. Detects the installed docker flavor (docker-ce or docker.io) and
#      installs the matching rootless extras plus uidmap and slirp4netns.
#   5. Disables docker.service, then docker.socket, confirming each stops.
#      Both block the rootless setuptool, and the socket triggers the service.
#      Then clears /var/run/docker.sock, which is the condition the setuptool
#      actually tests. A stale file is removed once both units are inactive.
#   6. Runs dockerd-rootless-setuptool.sh install, which writes a user unit to
#      ~/.config/systemd/user/docker.service and adds a "rootless" CLI context.
#   7. Enables systemd lingering so the daemon stays up after logout.
#   8. Enables and starts the docker user service, then verifies the result.
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Debian or Ubuntu, with systemd.
#   - Docker is already installed (docker-ce or docker.io).
#   - Sudo privileges, for apt and system service management.
#   - A real login session. Do not run this over plain `sudo` or a bare ssh
#     command, because `systemctl --user` needs the session bus.
#
# After this script:
#   - Uncomment DOCKER_HOST in nix/pkgs/docker.nix, then re-apply home-manager.
#     Also write ~/.config/environment.d/docker.conf, so GUI applications such
#     as VS Code inherit DOCKER_HOST. A shell profile does not reach them.
#   - Images, containers, and volumes are NOT migrated. The rootless daemon
#     starts empty, with its own state in ~/.local/share/docker. Nothing in
#     /var/lib/docker is read, moved, or deleted.
#   - Ports below 1024 are unavailable. Raise them with
#     net.ipv4.ip_unprivileged_port_start if you need them.
#
# Note:
#   This script is idempotent. Re-running it skips any step already done.
################################################################################

set -euo pipefail

USER_NAME=$(id -un)
USER_UID=$(id -u)
SOCKET="/run/user/${USER_UID}/docker.sock"
DRY_RUN=false
MODE=install

usage() {
    sed -n '/^# Usage:/,/^#$/p' "$0" | sed 's/^# \?//'
    exit "${1:-0}"
}

while [ $# -gt 0 ]; do
    case "$1" in
        --dry-run)   DRY_RUN=true ;;
        --uninstall) MODE=uninstall ;;
        -h|--help)   usage 0 ;;
        *)           echo "ERROR: unknown argument: $1" >&2; usage 1 ;;
    esac
    shift
done

# Print instead of execute when dry running, so every side effect is visible.
run() {
    if [ "${DRY_RUN}" = true ]; then
        printf '  WOULD RUN: %s\n' "$*"
    else
        "$@"
    fi
}

################################################################################
# uninstall: reverse every change this script makes
################################################################################
if [ "${MODE}" = uninstall ]; then
    echo "==> Reverting to rootful docker"

    if [ -f "${HOME}/.config/systemd/user/docker.service" ]; then
        run systemctl --user disable --now docker.service
        # -f is needed because the rootful socket may already be back.
        run dockerd-rootless-setuptool.sh uninstall -f
    else
        echo "  No rootless user unit found, nothing to remove"
    fi

    # Sequenced for the same reason as the disable path: one unit at a time.
    run sudo systemctl enable --now docker.socket
    run sudo systemctl enable --now docker.service

    echo ""
    echo "==> Reverted. /var/lib/docker was never touched, so all rootful"
    echo "    images, containers, and volumes are exactly as before."
    echo "    Remaining, both harmless and left deliberately:"
    echo "      - rootless state in ~/.local/share/docker"
    echo "        remove with: rootlesskit rm -rf ~/.local/share/docker"
    echo "      - systemd lingering, which other user services may rely on"
    echo "        remove with: sudo loginctl disable-linger ${USER_NAME}"
    echo "      - the uidmap package"
    echo "    Unset DOCKER_HOST, then confirm with: docker info | grep -i rootless"
    exit 0
fi

################################################################################
# install
################################################################################
[ "${DRY_RUN}" = true ] && echo "=== DRY RUN. No changes will be made. ==="

# 0. prefer podman when it is present. It is rootless by default and needs
#    none of the setup below.
if command -v podman >/dev/null 2>&1; then
    echo "podman is installed. Use podman instead of rootless docker."
    echo "  Podman runs rootless by default, so this script is unnecessary."
    echo "  Use 'podman' directly, or alias docker to podman."
    exit 0
fi

# 1. verify this is a Debian family system, as every install step below is apt
if ! command -v apt-get >/dev/null 2>&1; then
    echo "ERROR: apt-get not found. This script supports Debian and Ubuntu only." >&2
    echo "  On other distributions, install the rootless docker packages with" >&2
    echo "  the native package manager, then run dockerd-rootless-setuptool.sh install." >&2
    exit 1
fi

# 2. verify a systemd user session exists
if [ -z "${XDG_RUNTIME_DIR:-}" ] || ! systemctl --user show-environment >/dev/null 2>&1; then
    echo "ERROR: no systemd user session" >&2
    echo "  Run this from a normal desktop terminal or 'ssh -t', not from sudo." >&2
    exit 1
fi

# 3. verify subuid / subgid entries exist
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
echo "==> Checks passed: session, subuid, subgid"

# 4. install prerequisites for the docker flavor that is already present.
#    docker.io and docker-ce conflict, so never install one over the other.
if dpkg -s docker-ce >/dev/null 2>&1; then
    EXTRAS_PKG=docker-ce-rootless-extras
elif dpkg -s docker.io >/dev/null 2>&1; then
    EXTRAS_PKG=docker-rootless-extras
else
    echo "ERROR: neither docker-ce nor docker.io is installed" >&2
    echo "  Install docker first, then re-run this script." >&2
    exit 1
fi
echo "==> Docker flavor: ${EXTRAS_PKG%-rootless-extras}"

MISSING=()
for pkg in uidmap dbus-user-session slirp4netns "${EXTRAS_PKG}"; do
    dpkg -s "${pkg}" >/dev/null 2>&1 || MISSING+=("${pkg}")
done

if [ ${#MISSING[@]} -eq 0 ]; then
    echo "==> Prerequisites already installed"
elif [ "${DRY_RUN}" = true ]; then
    # apt simulation needs no privileges and reveals any conflicting removal.
    echo "==> apt simulation for: ${MISSING[*]}"
    apt-get install --dry-run "${MISSING[@]}" 2>&1 |
        grep -E '^(Inst|Remv|[0-9]+ upgraded)' | sed 's/^/  /'
else
    echo "==> Installing: ${MISSING[*]}"
    sudo apt update
    sudo apt install --yes "${MISSING[@]}"
fi

# newuidmap ships in uidmap and is what maps the subuid range. Without it
# rootlesskit fails with an opaque error.
if [ "${DRY_RUN}" = false ] && ! command -v newuidmap >/dev/null 2>&1; then
    echo "ERROR: newuidmap missing after installing uidmap" >&2
    exit 1
fi

# 5. disable the rootful daemon, which makes the setuptool abort.
#    docker.socket triggers docker.service, so both must go down. Disable them
#    one at a time and confirm each, because `disable --now a b` does not
#    guarantee the stop order and can leave the socket active.
disable_unit() {
    local unit=$1

    if ! systemctl is-enabled --quiet "${unit}" 2>/dev/null &&
       ! systemctl is-active --quiet "${unit}" 2>/dev/null; then
        echo "  ${unit}: already down"
        return 0
    fi

    echo "  ${unit}: disabling"
    run sudo systemctl disable --now "${unit}"
    [ "${DRY_RUN}" = true ] && return 0

    for _ in $(seq 1 10); do
        if ! systemctl is-active --quiet "${unit}" 2>/dev/null; then
            echo "  ${unit}: stopped"
            return 0
        fi
        sleep 1
    done

    echo "ERROR: ${unit} is still active after disable --now" >&2
    echo "  Check: systemctl status ${unit}" >&2
    exit 1
}

echo "==> Stopping the rootful daemon"
disable_unit docker.service
disable_unit docker.socket

# The setuptool aborts on `[ -w /var/run/docker.sock ]`, which tests the socket
# file, not the daemon. Group membership keeps a stale file writable, so mirror
# that exact test instead of only checking that the units stopped.
clear_rootful_socket() {
    [ -w /var/run/docker.sock ] || return 0

    echo "  /var/run/docker.sock is writable, which blocks the setuptool"
    run sudo systemctl stop docker.service
    run sudo systemctl stop docker.socket
    [ "${DRY_RUN}" = true ] && return 0

    for _ in $(seq 1 10); do
        if [ ! -w /var/run/docker.sock ]; then
            echo "  socket cleared"
            return 0
        fi
        sleep 1
    done

    # systemd leaves the file behind when the daemon exits outside its control.
    # Deleting it is only safe once both units are confirmed inactive.
    for unit in docker.socket docker.service; do
        if systemctl is-active --quiet "${unit}" 2>/dev/null; then
            echo "ERROR: ${unit} is still active, so the socket is in use" >&2
            echo "  Check: systemctl status ${unit}" >&2
            exit 1
        fi
    done

    echo "  Both units are inactive, so the socket file is stale. Removing it."
    run sudo rm -f /var/run/docker.sock

    if [ -w /var/run/docker.sock ]; then
        echo "ERROR: /var/run/docker.sock is still writable after removal" >&2
        exit 1
    fi
    echo "  stale socket removed"
}

clear_rootful_socket

# 6. run the setuptool as the current user, as it refuses to run as root
if [ -f "${HOME}/.config/systemd/user/docker.service" ]; then
    echo "==> User docker.service already present, skipping setuptool"
else
    echo "==> Running dockerd-rootless-setuptool.sh install"
    run dockerd-rootless-setuptool.sh install
fi

# 7. enable lingering so the daemon survives logout
if ! loginctl show-user "${USER_NAME}" 2>/dev/null | grep -q "Linger=yes"; then
    echo "==> Enabling systemd lingering for ${USER_NAME}"
    run sudo loginctl enable-linger "${USER_NAME}"
fi

# 8. enable, start, and verify
echo "==> Enabling and starting docker.service (user)"
run systemctl --user enable --now docker.service

if [ "${DRY_RUN}" = true ]; then
    echo ""
    echo "=== DRY RUN complete. Nothing changed. ==="
    echo "    Roll back a real run at any time with: $0 --uninstall"
    exit 0
fi

for _ in $(seq 1 10); do
    [ -S "${SOCKET}" ] && break
    sleep 1
done

if ! DOCKER_HOST="unix://${SOCKET}" docker info --format '{{.SecurityOptions}}' 2>/dev/null | grep -q rootless; then
    echo "ERROR: daemon did not come up rootless" >&2
    echo "  Check:    systemctl --user status docker.service" >&2
    echo "  Logs:     journalctl --user -u docker.service -n 50" >&2
    echo "  Roll back: $0 --uninstall" >&2
    exit 1
fi

echo ""
echo "==> Done. Rootless socket: ${SOCKET}"
echo "    1. Uncomment DOCKER_HOST in nix/pkgs/docker.nix and re-apply home-manager."
echo "    2. Add ~/.config/environment.d/docker.conf so GUI apps see it:"
echo "         DOCKER_HOST=unix://%t/docker.sock"
echo "    3. Log out and back in, then confirm: docker info | grep -i rootless"
echo "    4. Rootful images and volumes stay in /var/lib/docker, not visible here."
echo "    5. Roll back at any time with: $0 --uninstall"
