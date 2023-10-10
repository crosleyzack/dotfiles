#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Setup firefox. See https://support.mozilla.org/en-US/kb/install-firefox-linux
is_installed firefox
if [ "true" = "$INSTALLED" ]
then
    sudo apt update
    # install dependency and prevent it from being removed
    sudo apt install -y --reinstall libdbus-glib-1-2
    sudo apt-mark hold libdbus-glib-1-2
    # install firefox
    sudo rm -rf /opt/firefox
    sudo mkdir -p /opt
    mkdir -p $HOME/temp
    rm -f $HOME/temp/firefox.bz2
    curl -L -o $HOME/temp/firefox.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
    cd $HOME/temp && tar xjf firefox.bz2
    sudo cp -r $HOME/temp/firefox /opt
    rm $HOME/temp/firefox.bz2
    sudo rm /usr/local/bin/firefox
    sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
else
    echo "firefox already installed! Skipping"
fi


