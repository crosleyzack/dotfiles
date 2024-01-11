#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Install alacritty. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
is_installed alacritty
if [ "false" = "$INSTALLED" ]
then
    rm -rf $HOME/temp/alacritty
    mkdir -p $HOME/temp/
    git clone https://github.com/alacritty/alacritty.git $HOME/temp/alacritty
    #       Install requirements
    # ansible localhost -m ansible.builtin.package -a "name=cmake state=latest" -a "name=pkg-config state=latest" -a "name=libfreetype6-dev state=latest" -a "name=libfontconfig1-dev state=latest" -a "name=libxcb-xfixes0-dev state=latest" -a "name=libxkbcommon-dev state=latest" -a "name=python3 state=latest"
    sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    # set rustup and install. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
    rustup override set stable
    rustup update stable
    cd $HOME/temp/alacritty && cargo build --release
    #       Move to bin
    sudo cp $HOME/temp/alacritty/target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    sudo cp $HOME/temp/alacritty/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
    # Create .desktop file
    wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/compat/alacritty-term%2Bscanlines.png -o $HOME/Pictures/alacritty.png
    sudo rm -f /usr/share/applications/alacritty.desktop
    echo "[Desktop Entry]
Type=Application
Name=Alacritty
Exec=/usr/local/bin/alacritty
Comment=Executes Alacritty
Icon=/home/crosley/Pictures/alacritty.png" | sudo tee -a /usr/share/applications/alacritty.desktop
    # We shouldn't need this line, but execute it if not the default for some reason.
    echo "Select alacritty as new default terminal"
    sudo update-alternatives --config x-terminal-emulator
else
    echo "alacritty already installed! Skipping..."
fi

