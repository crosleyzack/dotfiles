#!/bin/bash

################################################################################
# Toolbox Container Rebuild Script
#
# Purpose:
#   Completely rebuilds the 'devs' toolbox container from scratch using a
#   custom Dockerfile.
#
# Behavior:
#   1. Stops the 'devs' container if running
#   2. Removes the existing 'devs' toolbox container
#   3. Removes the 'devs-image' from both toolbox and podman
#   4. Builds a new 'devs-image' from the Dockerfile in the script's directory
#   5. Creates a new 'devs' toolbox container from the rebuilt image
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - podman installed
#   - toolbox installed
#   - Dockerfile must exist in the script's directory
################################################################################

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

podman stop -i devs
toolbox rm -f devs
toolbox rmi -f devs-image
podman rmi -f devs-image
podman build -t devs-image --label=devbox -f "$DIR/Dockerfile" .
toolbox create --image devs-image devs
