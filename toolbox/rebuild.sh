#!/bin/bash

FILE_PATH=$(realpath $BASH_SOURCE)
DIR=$(dirname $FILE_PATH)

podman stop devs
toolbox rm devs
toolbox rmi devs-image
podman build -t devs-image --label=devbox -f "$DIR/Dockerfile" .
toolbox create --image devs-image devs
