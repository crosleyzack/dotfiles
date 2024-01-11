#!/bin/bash

wget https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Visual_Studio_Code_1.35_icon.svg/480px-Visual_Studio_Code_1.35_icon.svg.png -O $HOME/Pictures/code.png
sudo rm -f /usr/share/applications/code.desktop
echo "[Desktop Entry]
Type=Application
Name=Code
Exec=$(which code)
Comment=Executes VSCode
Icon=/home/crosley/Pictures/code.png" | sudo tee -a /usr/share/applications/code.desktop
