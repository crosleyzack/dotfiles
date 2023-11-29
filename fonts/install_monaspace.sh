#!/bin/bash

mkdir -p ~/temp
rm -rf ~/temp/monaspace
mkdir -p ~/.local/share/fonts
git clone git@github.com:githubnext/monaspace.git ~/temp/monaspace
cd ~/temp/monaspace && ./utils/install_linux.sh
