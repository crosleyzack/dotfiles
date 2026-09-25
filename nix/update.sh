#!/bin/bash

################################################################################
# Nix Home Manager Update Script
#
# Purpose:
#   Updates Nix channels and applies the latest home-manager configuration.
#
# Behavior:
#   1. Updates all Nix channels to fetch the latest package definitions
#   2. Runs nix flake update to get the latest nixpkgs revision
#   3. Checks that large packages are available in the binary cache; reverts flake.lock if not
#   4. Switches to the updated home-manager configuration using the flake
#   5. Creates a backup of the previous configuration before switching
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - home-manager must be installed
#   - flake.nix must hold a configuration under the name of this user
################################################################################

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

# The id names the configuration of flake.nix. install.sh wrote the file, and
# home manager sets the variable in every login shell. Either one serves.
SYSTEM_ID_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/nix-system-id"
NIX_SYSTEM_ID="${NIX_SYSTEM_ID:-}"
if [ -z "$NIX_SYSTEM_ID" ] && [ -r "$SYSTEM_ID_FILE" ]; then
    NIX_SYSTEM_ID="$(cat "$SYSTEM_ID_FILE")"
fi
if [ ! -d "$DIR_PATH/$NIX_SYSTEM_ID" ]; then
    printf "Error: no configuration for system '%s'.\nRun install.sh, or set NIX_SYSTEM_ID to 'framework', 'lenovo', or 'google'.\n" "$NIX_SYSTEM_ID" >&2
    exit 1
fi
echo "updating $NIX_SYSTEM_ID system"

# Update flake inputs to get the latest nixpkgs revision
nix flake update --flake $DIR_PATH

# Packages that should never be built from source (e.g. they take hours to compile).
# If any of these are not in the binary cache, revert flake.lock and wait for the cache to catch up.
PACKAGES_TO_NEVER_BUILD=(
    chromium # bazecor (electron app), vhs (uses playwright for rendering)
    dotnet-sdk # azure-cli
    vscode
    mysql84
    postgresql
    gcc
)

# Use the nixpkgs revision from the flake.lock to match what home-manager will actually build
NIXPKGS_REV=$(jq -r '.nodes.nixpkgs.locked.rev' $DIR_PATH/flake.lock)
for pkg in "${PACKAGES_TO_NEVER_BUILD[@]}"; do
    if nix build "github:NixOS/nixpkgs/${NIXPKGS_REV}#${pkg}" \
        --option extra-substituters "https://nix-community.cachix.org" \
        --dry-run 2>&1 | grep -q "will be built"; then
        echo "ERROR: ${pkg} is not in the binary cache and would be built from source. Reverting flake.lock."
        echo "Try again in a few hours once the cache has caught up."
        git -C $DIR_PATH checkout -- flake.lock
        exit 1
    fi
done

# home-manager switch. The text after "#" names the configuration of flake.nix,
# which holds one for each machine under the id of that machine.
cd $DIR_PATH && home-manager switch -b backup --flake ".#$NIX_SYSTEM_ID"

# delete older generations. 10 days arbitrary to balance having generations
# to revert to while minimizing storage
home-manager expire-generations "-10 days"
nix-collect-garbage
