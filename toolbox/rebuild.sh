#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

podman stop -i devs
toolbox rm -f devs
toolbox rmi -f devs-image
podman rmi -f devs-image
podman build -t devs-image --label=devbox -f "$DIR/Dockerfile" .
toolbox create --image devs-image devs
