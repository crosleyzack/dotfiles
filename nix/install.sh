#!/bin/bash

################################################################################
# Nix Package Manager Installation and Configuration Script
#
# Purpose:
#   Installs and configures Nix package manager and home-manager.
#   This script performs a single-user installation (--no-daemon) and
#   sets up system-specific configurations.
#
# Behavior:
#   1. Auto-detects or uses provided system ID to apply machine-specific configs
#   2. Binds /nix to persistent storage, on a system that needs it
#   3. Installs Nix package manager if not already present
#   4. Configures Nix channels (nixpkgs stable)
#   5. Installs home-manager and sets up the appropriate channel
#   6. Applies home-manager flake configuration from the system-specific directory
#
# Environment Variables:
#   NIX_VERSION              - Nix channel version to install (default: 25.11)
#                              See: https://nixos.wiki/wiki/Nix_channels
#   SETUP_NIX_CHANNEL        - Whether to setup Nix channels (default: true)
#   SETUP_HOME_MANAGER       - Whether to install home-manager (default: true)
#   NIX_SYSTEM_ID            - System identifier: 'framework', 'lenovo', or 'google'
#                              Auto-detected via dmidecode if not set
#   NIX_STORE_BACKING        - Directory that holds the store, bound onto /nix
#                              (default: $HOME/nix on 'google', empty elsewhere)
#                              Set to 'none' to keep the store on the root disk
#   NIX_INSTALLER_CHECKSUM   - Expected SHA256 checksum of Nix installer script
#                              REQUIRED for security. Update periodically from official sources
#
# Store location:
#   The store path is always /nix, because nix writes that absolute path into
#   its build results, and a different path makes the binary cache useless.
#   NIX_STORE_BACKING moves only the storage behind it, with a bind mount.
#   Use it when the root filesystem is disposable but a data disk is not: a
#   'google' system is a cloud VM, which gets a new root disk from its image
#   at every start. See utils/bind-store.sh.
#
# Security:
#   To update the expected checksum, download the installer and run:
#     curl -fSL https://nixos.org/nix/install | sha256sum
#   Then update NIX_INSTALLER_CHECKSUM below or pass as environment variable.
#
# Note:
#   This script can also be run to update the Nix version by changing the
#   NIX_VERSION environment variable to the desired version.
################################################################################

# NOTE: this can also be run to update nix version. Simply change `VERSION` below to the appropriate value. See https://nixos.wiki/wiki/Nix_channels
VERSION="${NIX_VERSION:-26.05}"
SETUP_CHANNEL="${SETUP_NIX_CHANNEL:-true}"
INSTALL_HOME_MANAGER="${SETUP_HOME_MANAGER:-true}"
# Resolve the system id here, not at the home-manager step: the store
# location default depends on it.
NIX_SYSTEM_ID="${NIX_SYSTEM_ID:-}"
if [ -z "$NIX_SYSTEM_ID" ]; then
    if ! command -v dmidecode &>/dev/null; then
        printf "Error: NIX_SYSTEM_ID is not set and dmidecode is not installed.\nSet NIX_SYSTEM_ID to 'framework', 'lenovo', or 'google'.\n" >&2
        exit 1
    fi
    NIX_SYSTEM_ID="$(sudo dmidecode -s system-manufacturer | awk '{print tolower($0)}')"
fi

# Where the store really lives. A google system is a cloud VM: its root disk,
# and thus /nix, comes from the image at every start, so the store must sit on
# the home disk. See the "Store location" note above.
NIX_STORE_BACKING="${NIX_STORE_BACKING:-}"
if [ -z "$NIX_STORE_BACKING" ] && [ "$NIX_SYSTEM_ID" == "google" ]; then
    NIX_STORE_BACKING="$HOME/nix"
fi

# Expected SHA256 checksum of the Nix installer script
# REQUIRED: This checksum is mandatory for security.
# Update this periodically by running: curl -fSL https://nixos.org/nix/install | sha256sum
# Verify the checksum against official Nix documentation or trusted sources before setting.
# Last verified: 2026-03-27
# This MUST be set before running the script.
NIX_INSTALLER_CHECKSUM="${NIX_INSTALLER_CHECKSUM:-9adda97297d9e8ab360df95c729eabff4f4f93d6db091953c3a68f29e3fb130c}"

printf "SETUP_CHANNEL=$SETUP_CHANNEL; INSTALL_HOME_MANAGER=$INSTALL_HOME_MANAGER; NIX_SYSTEM_ID=$NIX_SYSTEM_ID; NIX_STORE_BACKING=${NIX_STORE_BACKING:-none}\n"

# get dir containing this file
FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# Put the store on persistent storage before anything looks for one at /nix.
# --migrate keeps a store that a previous run left on the root disk.
if [ -n "$NIX_STORE_BACKING" ] && [ "$NIX_STORE_BACKING" != "none" ]; then
    printf "\nbacking /nix with $NIX_STORE_BACKING...\n"
    if ! "$DIR_PATH/utils/bind-store.sh" --migrate "$NIX_STORE_BACKING"; then
        printf "Error: could not bind %s onto /nix\n" "$NIX_STORE_BACKING" >&2
        exit 1
    fi
fi

# Install nix package manager. A restored store already holds nix, but PATH
# does not show it until a new shell reads the profile, thus test both.
if [[ -z "$(which nix-env)" && ! -x "$HOME/.nix-profile/bin/nix-env" ]]; then
    printf "\nnix not installed, installing..."

    mkdir -p $HOME/.config/nix

    # install
    INSTALLER_URL="https://nixos.org/nix/install"
    TEMP_INSTALLER=$(mktemp)

    printf "\nDownloading Nix installer from $INSTALLER_URL...\n"
    if ! curl --proto '=https' --tlsv1.2 -fSL "$INSTALLER_URL" -o "$TEMP_INSTALLER"; then
        printf "Error: Failed to download Nix installer from $INSTALLER_URL\n" >&2
        rm -f "$TEMP_INSTALLER"
        exit 1
    fi

    if [ ! -s "$TEMP_INSTALLER" ]; then
        printf "Error: Downloaded Nix installer is empty\n" >&2
        rm -f "$TEMP_INSTALLER"
        exit 1
    fi

    # Verify checksum (REQUIRED - no bypass allowed)
    if [ -z "$NIX_INSTALLER_CHECKSUM" ]; then
        printf "\nError: NIX_INSTALLER_CHECKSUM is not set!\n" >&2
        printf "Checksum verification is REQUIRED for security.\n\n" >&2
        printf "To set the checksum:\n" >&2
        printf "1. Calculate the checksum of the downloaded installer:\n" >&2
        printf "   CHECKSUM=\$(sha256sum \"$TEMP_INSTALLER\" | awk '{print \$1}')\n" >&2
        printf "   echo \"Installer checksum: \$CHECKSUM\"\n\n" >&2
        printf "2. Verify this checksum against official Nix sources:\n" >&2
        printf "   - Check Nix documentation\n" >&2
        printf "   - Compare with known good installations\n" >&2
        printf "   - Inspect the installer: less $TEMP_INSTALLER\n\n" >&2
        printf "3. Once verified, set the checksum and re-run:\n" >&2
        printf "   export NIX_INSTALLER_CHECKSUM=\"<verified-checksum>\"\n" >&2
        printf "   ./install.sh\n\n" >&2
        printf "The installer has been left at: $TEMP_INSTALLER\n" >&2
        printf "Delete it when done: rm $TEMP_INSTALLER\n" >&2
        exit 1
    fi

    printf "Verifying installer checksum...\n"
    ACTUAL_CHECKSUM=$(sha256sum "$TEMP_INSTALLER" | awk '{print $1}')

    if [ "$ACTUAL_CHECKSUM" != "$NIX_INSTALLER_CHECKSUM" ]; then
        printf "\nError: Checksum verification FAILED!\n" >&2
        printf "  Expected: %s\n" "$NIX_INSTALLER_CHECKSUM" >&2
        printf "  Got:      %s\n" "$ACTUAL_CHECKSUM" >&2
        printf "\nThe installer may have been tampered with or updated.\n" >&2
        printf "DO NOT proceed unless you can verify the new checksum is legitimate.\n\n" >&2
        printf "If the Nix installer has been officially updated:\n" >&2
        printf "1. Verify the new checksum against official sources\n" >&2
        printf "2. Update NIX_INSTALLER_CHECKSUM in this script or set via environment:\n" >&2
        printf "   export NIX_INSTALLER_CHECKSUM=\"%s\"\n" "$ACTUAL_CHECKSUM" >&2
        printf "3. Re-run the installation\n" >&2
        rm -f "$TEMP_INSTALLER"
        exit 1
    fi
    printf "✓ Checksum verified successfully\n"

    printf "\nRunning Nix installer...\n"
    sh "$TEMP_INSTALLER" --no-daemon --yes
    INSTALL_EXIT_CODE=$?
    rm -f "$TEMP_INSTALLER"

    if [ $INSTALL_EXIT_CODE -ne 0 ]; then
        printf "Error: Nix installation failed with exit code %d\n" $INSTALL_EXIT_CODE >&2
        exit $INSTALL_EXIT_CODE
    fi
fi

# ensure nix has been sourced
source $HOME/.nix-profile/etc/profile.d/nix.sh

# Add nixpkgs stable and unstable
if $SETUP_CHANNEL; then
    printf "\nsetting up channel https://channels.nixos.org/nixos-$VERSION..."
    # remove the default channels
    nix-channel --remove unstable
    nix-channel --remove nixpkgs

    # add specified version
    nix-channel --add "https://channels.nixos.org/nixos-$VERSION" nixpkgs
    nix-channel --update
fi

# Install home manager
if $INSTALL_HOME_MANAGER; then
    printf "\ninstalling home manager"

    # add and sync channel
    nix-channel --remove home-manager
    nix-channel --add "https://github.com/nix-community/home-manager/archive/release-$VERSION.tar.gz" home-manager
    nix-channel --update

    # install home manager
    nix-shell '<home-manager>' -A install
    source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh

    # setup system link, depending on system name
    rm -f $DIR_PATH/system
    printf "\nconfiguring as $NIX_SYSTEM_ID system..."
    case "$NIX_SYSTEM_ID" in
        framework|lenovo|google) ln -s "$DIR_PATH/$NIX_SYSTEM_ID" "$DIR_PATH/system" ;;
        *)
            printf "\nError: no configuration for system '%s'.\nSet NIX_SYSTEM_ID to 'framework', 'lenovo', or 'google'.\n" "$NIX_SYSTEM_ID" >&2
            exit 1
            ;;
    esac

    cd "$DIR_PATH/system" && NIX_CONFIG="experimental-features = nix-command flakes cgroups" home-manager switch -b backup --flake .
fi

printf "\nInstall completed. Relaunch shell to use nix\n"
