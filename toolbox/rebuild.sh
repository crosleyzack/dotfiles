#!/bin/bash

podman stop devs
toolbox rm devs
toolbox rmi devs-image
podman build -t devs-image --label=devbox -f Dockerfile .
toolbox create --image devs-image devs
