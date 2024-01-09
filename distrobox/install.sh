#!/bin/bash

PARENT="${BASH_SOURCE%/*}"
source "$PARENT/../tools/install_tools.sh"

is_installed distrobox
if [ "true" = "$INSTALLED" ]
then
    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/uninstall | sudo sh
fi

# install
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

# symbolic links to config
sudo rm -f $HOME/distrobox.ini
echo "Linking $HOME/distrobox.ini to $BASE_DIR/distrobox/distrobox.ini"
sudo ln -s $BASE_DIR/distrobox/distrobox.ini $HOME/distrobox.ini
sudo rm -f $HOME/.config/distrobox/distrobox.conf
sudo mkdir -p $HOME/.config/distrobox
echo "Linking $HOME/.config/distrobox/distrobox.conf to $BASE_DIR/distrobox/distrobox.conf"
sudo ln -s $BASE_DIR/distrobox/distrobox.conf $HOME/.config/distrobox/distrobox.conf

# Setup distrobox
distrobox assemble rm --file $PARENT/distrobox.ini
distrobox assemble create --file $PARENT/distrobox.ini
