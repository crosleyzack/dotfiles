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
#   1. Installs Nix package manager if not already present
#   2. Configures Nix channels (nixpkgs stable)
#   3. Installs home-manager and sets up the appropriate channel
#   4. Auto-detects or uses provided system ID to apply machine-specific configs
#   5. Applies home-manager flake configuration from the system-specific directory
#
# Environment Variables:
#   NIX_VERSION              - Nix channel version to install (default: 25.11)
#                              See: https://nixos.wiki/wiki/Nix_channels
#   SETUP_NIX_CHANNEL        - Whether to setup Nix channels (default: true)
#   SETUP_HOME_MANAGER       - Whether to install home-manager (default: true)
#   NIX_SYSTEM_ID            - System identifier: 'framework', 'lenovo', or 'google'
#                              Auto-detected via dmidecode if not set
#   NIX_INSTALLER_CHECKSUM   - Expected SHA256 checksum of Nix installer script
#                              REQUIRED for security. Update periodically from official sources
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
NIX_SYSTEM_ID="${NIX_SYSTEM_ID:-''}"
if [ -z "$NIX_SYSTEM_ID" ]; then
    if ! command -v dmidecode &>/dev/null; then
        printf "Error: NIX_SYSTEM_ID is not set and dmidecode is not installed.\nSet NIX_SYSTEM_ID to 'framework', 'lenovo', or 'google'.\n" >&2
        exit 1
    fi
fi

# Expected SHA256 checksum of the Nix installer script
# REQUIRED: This checksum is mandatory for security.
# Update this periodically by running: curl -fSL https://nixos.org/nix/install | sha256sum
# Verify the checksum against official Nix documentation or trusted sources before setting.
# Last verified: 2026-03-27
# This MUST be set before running the script.
NIX_INSTALLER_CHECKSUM="${NIX_INSTALLER_CHECKSUM:-9adda97297d9e8ab360df95c729eabff4f4f93d6db091953c3a68f29e3fb130c}"

printf "SETUP_CHANNEL=$SETUP_CHANNEL; INSTALL_HOME_MANAGER=$INSTALL_HOME_MANAGER; NIX_SYSTEM_ID=$NIX_SYSTEM_ID\n"

# get dir containing this file
FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# Install nix package manager
if [[ -z "$(which nix-env)" ]]; then
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
    if [ -z $NIX_SYSTEM_ID ]; then 
        NIX_SYSTEM_ID="$(sudo dmidecode -s system-manufacturer| awk '{print tolower($0)}')";
    fi
    printf "\nconfiguring as $NIX_SYSTEM_ID system..."
    [ "$NIX_SYSTEM_ID" == "framework" ] && ln -s $DIR_PATH/framework $DIR_PATH/system
    [ "$NIX_SYSTEM_ID" == "lenovo" ] && ln -s $DIR_PATH/lenovo $DIR_PATH/system
    [ "$NIX_SYSTEM_ID" == "google" ] && ln -s $DIR_PATH/google $DIR_PATH/system

    cd system && NIX_CONFIG="experimental-features = nix-command flakes cgroups" home-manager switch -b backup --flake .
fi

printf "\nInstall completed. Relaunch shell to use nix\n"
