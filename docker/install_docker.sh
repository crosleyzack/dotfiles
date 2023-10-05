#!/bin/bash


source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Setup docker. See https://docs.docker.com/engine/install/debian
is_installed docker-ce
if [ "false" = "$INSTALLED" ]
then
     # Add Docker's official GPG key:
     sudo apt-get update
     sudo apt-get install ca-certificates curl gnupg
     sudo install -m 0755 -d /etc/apt/keyrings
     curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
     sudo chmod a+r /etc/apt/keyrings/docker.gpg

     # Add the repository to Apt sources:
     echo \
       "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
       "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
     sudo apt-get update
     sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
     sudo groupadd -f docker
     sudo usermod -aG docker $USER
     newgrp docker

     # sym link daemon
     # sudo mkdir -p /etc/docker
     # sudo rm -f /etc/docker/daemon.json
     # echo "Linking /etc/docker/deamon.json to $BASE_DIR/docker/daemon.json"
     # sudo ln -s $BASE_DIR/docker/daemon.json /etc/docker/daemon.json
else
     echo "docker-ce already installed! Skipping"
fi

is_installed docker-compose
if [ "false" = "$INSTALLED" ]
then
    # Create a symbolic link
    sudo rm -f /usr/local/bin/docker-compose
    sudo ln -f -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
    # sudo touch /usr/bin/docker-compose
    # echo "docker compose \"$@\"" > /usr/bin/docker-compose
else
     echo "docker-compose already installed! Skipping"
fi

# Setup docker desktop. https://docs.docker.com/desktop/install/debian/
# is_installed docker-compose
# if [ "false" = "$INSTALLED" ]
# then
    # # install curl if not already
    # sudo apt-get update
    # sudo apt-get install curl
    # # get new copy of deb file
    # mkdir -p $HOME/temp
    # rm -f $HOME/temp/docker-desktop.deb
    # curl -SL -o $HOME/temp/docker-desktop.deb https://desktop.docker.com/linux/main/amd64/docker-desktop-4.24.0-amd64.deb
    # # install deb file
    # sudo apt-get install -y $HOME/temp/docker-desktop.deb
    # # set to run at startup
    # systemctl --user enable docker-desktop
# else
    # echo "docker-compose already installed! Skipping"
# fi
