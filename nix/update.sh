#!/bin/bash

################################################################################
# Nix Home Manager Update Script
#
# Purpose:
#   Updates Nix channels and applies the latest home-manager configuration.
#
# Behavior:
#   1. Verifies that a system symlink exists (pointing to the flake directory)
#   2. Updates all Nix channels to fetch the latest package definitions
#   3. Runs nix flake update to get the latest nixpkgs revision
#   4. Checks that large packages are available in the binary cache; reverts flake.lock if not
#   5. Switches to the updated home-manager configuration using the flake
#   6. Creates a backup of the previous configuration before switching
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - A 'system' symlink must exist in the script's directory pointing to a
#     flake directory (framework, lenovo, or google)
#   - home-manager must be installed
################################################################################

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

if [ ! -L $DIR_PATH/system ]; then
    echo "system not found, run `ln -s <flake dir> system` with correct directory"
    exit 1
fi

# nix-channel --update

# Update flake inputs to get the latest nixpkgs revision
nix flake update --flake $DIR_PATH/system

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
NIXPKGS_REV=$(jq -r '.nodes.nixpkgs.locked.rev' $DIR_PATH/system/flake.lock)
for pkg in "${PACKAGES_TO_NEVER_BUILD[@]}"; do
    if nix build "github:NixOS/nixpkgs/${NIXPKGS_REV}#${pkg}" \
        --option extra-substituters "https://nix-community.cachix.org" \
        --dry-run 2>&1 | grep -q "will be built"; then
        echo "ERROR: ${pkg} is not in the binary cache and would be built from source. Reverting flake.lock."
        echo "Try again in a few hours once the cache has caught up."
        git -C $DIR_PATH/system checkout -- flake.lock
        exit 1
    fi
done

# home-manager switch
cd $DIR_PATH/system && home-manager switch -b backup --flake .

# delete older generations. 10 days arbitrary to balance having generations
# to revert to while minimizing storage
home-manager expire-generations "-10 days"
nix-collect-garbage
