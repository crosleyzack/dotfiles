#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Install alacritty. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
is_installed alacritty
if [ "false" = "$INSTALLED" ]
then
    rm -rf ~/temp/alacritty
    mkdir -p ~/temp/alacritty
    cd ~/temp/alacritty
    git clone https://github.com/alacritty/alacritty.git
    cd alacritty
    #       Install requirements
    sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    cargo build --release
    #       Move to bin
    sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
    # We shouldn't need this line, but execute it if not the default for some reason.
    sudo update-alternatives --config x-terminal-emulator
    # Create .desktop file
    sudo rm -f /usr/share/applications/alacritty.desktop
    sudo echo "[Desktop Entry]
Type=Application
Name=Alacritty
Exec=/usr/local/bin/alacritty
Comment=Executes Alacritty
Icon=/home/crosley/Pictures/alacritty.png" >> /usr/share/applications/alacritty.desktop
else
    echo "alacritty already installed! Skipping..."
fi
