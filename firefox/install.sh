#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# To remove firefox-esr on debian, do:
#  sudo apt purge firefox-esr

# Setup firefox. See https://support.mozilla.org/en-US/kb/install-firefox-linux
is_installed firefox
if [ "false" = "$INSTALLED" ]
then
    # install dependency and prevent it from being removed
    # ansible localhost -m ansible.builtin.package -a "name=libdbus-glib-1-2 state=present"
    sudo apt update
    sudo apt install -y --reinstall libdbus-glib-1-2
    sudo apt-mark hold libdbus-glib-1-2
    # remove existing firefox
    sudo rm -rf /opt/firefox
    # sanity
    sudo mkdir -p /opt
    # pull and extract firefox
    mkdir -p $HOME/temp
    rm -f $HOME/temp/firefox.bz2
    curl -L -o $HOME/temp/firefox.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
    rm -f $HOME/temp/firefox
    tar xjf $HOME/temp/firefox.bz2 -C $HOME/temp
    # move to final install location
    sudo cp -r $HOME/temp/firefox /opt
    sudo rm -f /usr/local/bin/firefox
    sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
    # cleanup
    rm -f $HOME/temp/firefox.bz2
    rm -rf $HOME/temp/firefox
    # Create deskop file
    wget https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Firefox_logo%2C_2019.png/636px-Firefox_logo%2C_2019.png -O $HOME/Pictures/firefox.png
    sudo rm -f /usr/share/applications/firefox.desktop
    echo "[Desktop Entry]
Type=Application
Name=Firefox
Exec=/usr/local/bin/firefox
Comment=Executes Firefox
Icon=/home/crosley/Pictures/firefox.png" | sudo tee -a /usr/share/applications/     firefox.desktop
else
    echo "firefox already installed! Skipping"
fi
