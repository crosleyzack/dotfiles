#!/bin/sh
# exec flatpak-spawn --host podman "${@}"
# https://discussion.fedoraproject.org/t/vscode-devcontainers/45874/7

FILE_PATH=$(realpath $BASH_SOURCE)
DIR_PATH=$(dirname $FILE_PATH)

echo "exec flatpak-spawn --host podman \"${@}\"" >> $DIR_PATH/podman_host.sh
chmod u+x $DIR_PATH/podman_host.sh
rm -f $HOME/.local/bin/podman-host
ln -s $DIR_PATH/podman_host.sh $HOME/.local/bin/podman-host
