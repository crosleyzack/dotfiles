#!/bin/bash

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

LOC=$HOME/bin

# Install alacritty. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
is_installed alacritty
if [ "false" = "$INSTALLED" ]
then
    # Automatic Install
    # cargo install alacritty
    # Install RUST
    # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    rm -rf $LOC/alacritty
    mkdir -p $LOC
    git clone https://github.com/alacritty/alacritty.git $LOC/alacritty
    # Install requirements
    #   ansible localhost -m ansible.builtin.package -a "name=cmake state=latest" -a "name=pkg-config state=latest" -a "name=libfreetype6-dev state=latest" -a "name=libfontconfig1-dev state=latest" -a "name=libxcb-xfixes0-dev state=latest" -a "name=libxkbcommon-dev state=latest" -a "name=python3 state=latest"
    #   dnf install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++
    #   sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    #   set rustup and install. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
    rustup override set stable && rustup update stable
    cd $LOC/alacritty && cargo build --release
    # Move to bin
    #   sudo ln -s $LOC/alacritty/target/release/alacritty /usr/local/bin # or anywhere else in $PATH
    #   sudo ln -s $LOC/alacritty/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo cp $LOC/alacritty/target/release/alacritty /usr/local/bin
    sudo cp $LOC/alacritty/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    # Create .desktop file
    sudo desktop-file-install $LOC/alacritty/extra/linux/Alacritty.desktop
    sudo update-desktop-database
    # Manual install of desktops
    # wget https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/compat/alacritty-term%2Bscanlines.png -O $HOME/Pictures/alacritty.png
    # sudo rm -f /usr/share/applications/alacritty.desktop
    # echo "[Desktop Entry]
    # Type=Application
    # Name=Alacritty
    # Exec=/usr/local/bin/alacritty
    # Comment=Executes Alacritty
    # Icon=/home/crosley/Pictures/alacritty.png" | sudo tee -a /usr/share/applications/alacritty.desktop
    # We shouldn't need this line, but execute it if not the default for some reason.
    # DEBIAN
    # sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
    # echo "Select alacritty as new default terminal"
    # sudo update-alternatives --config x-terminal-emulator
else
    echo "alacritty already installed! Skipping..."
fi

