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
#   3. Switches to the updated home-manager configuration using the flake
#   4. Creates a backup of the previous configuration before switching
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

nix-channel --update

# home-manager switch 
cd $DIR_PATH/system && home-manager switch -b backup --flake .

# delete older generations. 15 days arbitrary to balance having generations
# to revert to while minimizing storage
home-manager expire-generations "-15 days"
