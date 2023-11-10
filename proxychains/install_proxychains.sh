#!/bin/bash

echo "WARNING! If you are using nix, you don't want to install this! Backout now!"
sleep 10
echo "WARNING! Was not cancelled, continuing!"

source "${BASH_SOURCE%/*}/install_tools.sh"

# Install Proxychains
is_installed proxychains
if [ "false" = "$INSTALLED" ]
then
    get_git https://github.com/haad/proxychains.git
    cd $HOME/temp/proxychains && ./configure && make && sudo make install
else
    echo "Proxychains already installed! Skipping..."
fi
