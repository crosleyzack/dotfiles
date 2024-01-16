#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Setup docker. See https://docs.docker.com/engine/install/debian
is_installed docker-ce
if [ "false" = "$INSTALLED" ]
then
     # Add Docker's official GPG key:
     # ansible localhost -m ansible.builtin.package -a "name=curl state=latest" -a "name=gnupg state=latest" -a "name=ca-certificates state=latest"
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
     # add group: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
     sudo groupadd -f docker
     sudo usermod -aG docker $USER
     newgrp docker
     sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
     sudo chmod g+rwx "$HOME/.docker" -R
     # sym link daemon
     # sudo mkdir -p /etc/docker
     # sudo rm -f /etc/docker/daemon.json
     # echo "Linking /etc/docker/deamon.json to $BASE_DIR/docker/daemon.json"
     # sudo ln -s $BASE_DIR/docker/daemon.json /etc/docker/daemon.json
     # launch with system: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd
     sudo systemctl enable docker.service
     sudo systemctl enable containerd.service
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
# is_installed docker-desktop
# if [ "false" = "$INSTALLED" ]
# then
#     # remove old
#     rm -rf $HOME/.docker/desktop
#     sudo rm -f /usr/local/bin/com.docker.cli
#     sudo apt purge docker-desktop
#     # # install curl if not already
#     sudo apt-get update
#     # # get new copy of deb file
#     mkdir -p $HOME/temp
#     rm -f $HOME/temp/docker-desktop.deb
#     curl -SL -o $HOME/temp/docker-desktop.deb https://desktop.docker.com/linux/main/amd64/docker-desktop-4.25.1-amd64.deb
#     # install deb file
#     sudo apt-get install -y $HOME/temp/docker-desktop.deb
#     # # set to run at startup
#     systemctl --user enable docker-desktop
# else
#     echo "docker-desktop already installed! Skipping"
# fi
