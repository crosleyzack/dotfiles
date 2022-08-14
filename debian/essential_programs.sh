#!/bin/bash
sudo apt update
sudo apt install snapd

# Function to check if a package or command is installed.
# Will set $INSTALLED to "true" if found, "false" if not.
# $1 package name
function is_installed {
        if [ "install ok installed" = "$(dpkg-query -W --showformat='${Status}\n' $1 | grep 'install ok installed')" ]
        then
                # If we find the name in dpkg, then it is installed.
                echo "Package $1 is installed!"
                INSTALLED="true"
        elif [ "" != $(command -v $1) ]
        then
                # If a command of this name exists, then it is installed.
                echo "Package $1 is installed!"
                INSTALLED="true"
        else
                echo "Package $1 NOT installed!"
                INSTALLED="false"
        fi
}

# Install spotify.
is_installed spotify
if [ "false" = "$INSTALLED" ]
then
	# sudo snap install spotify
        curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add -
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        sudo apt update
        sudo apt install spotify-client
else
        echo "Spotify already installed! Skipping..."
fi


# Install slack.
is_installed slack
if [ "false" = "$INSTALLED" ]
then
	sudo snap install slack
	# NOTE non-snap version has issues: https://github.com/Foundry376/Mailspring/issues/2154
        # mkdir ~/temp
        # cd ~/temp
        # wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb
	# sudo apt install ./slack-desktop-*.deb
else
        echo "Slack already installed! Skipping..."
fi


# Install VS code.
is_installed code
if [ "false" = "$INSTALLED" ]
then
	# sudo snap install code --classic
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt update
	sudo apt install code
else
        echo "VS Code already installed! Skipping..."
fi

# Install Brew. See https://brew.sh
is_installed brew
if [ "false" = "$INSTALLED" ]
then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/$USER/.zprofile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
        echo "Brew already installed! Skipping..."
fi

# Use brew to install fontconfig. This is unfortunately required for alacritty to work.
#       See https://github.com/alacritty/alacritty/issues/5564
is_installed fontconfig
if [ "false" = "$INSTALLED" ]
then
        brew install fontconfig
else
        echo "fontconfig already installed! Skipping..."
fi

# Install alacritty. See https://github.com/alacritty/alacritty/blob/master/INSTALL.md
is_installed alacritty
if [ "false" = "$INSTALLED" ]
then
        rm -rf ~/temp/alacritty
        mkdir ~/temp/alacritty
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
        # sudo update-alternatives --config x-terminal-emulator
else
        echo "alacritty already installed! Skipping..."
fi


# Install zsh / oh-my-zsh
is_installed zsh
if [ "false" = "$INSTALLED" ]
then
        # setup zsh
        sudo apt install zsh
        # setup oh my zsh
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        # Setup spaceship prompt
        rm -rf ~/temp/zsh
        mkdir ~/temp/zsh
        cd ~/temp/zsh
        zsh -c "$(git clone https://github.com/spaceship-prompt/spaceship-prompt.git '$ZSH_CUSTOM/themes/spaceship-prompt' --depth=1)"
        zsh -c "$(ln -s '$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme' '$ZSH_CUSTOM/themes/spaceship.zsh-theme')"
        # Set default terminal in alacritty to zsh
        alacritty -e chsh -s $(which zsh)
fi
