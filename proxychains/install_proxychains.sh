#!/bin/bash

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
