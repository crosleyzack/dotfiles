#!/bin/bash

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


# Install some apt packages
sudo apt update
sudo apt upgrade
sudo apt install tmux \
	gcc \
	cmake \
	make \
	build-essential \
	ca-certificates \
	curl \
	gnupg \
	lsb-release \
	jq \
	git \
	apt-transport-https \
	texlive-latex-extra \
	texlive-fonts-extra \
	vim \
	fonts-powerline


# Setup docker. See https://docs.docker.com/engine/install/ubuntu/
is_installed docker-ce
if [ "false" = "$INSTALLED" ]
then
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
else
	echo "docker-ce already installed! Skipping"
fi


# Setup google cloud CLI. See https://cloud.google.com/sdk/docs/install
is_installed google-cloud-cli
if [ "false" = "$INSTALLED" ]
then
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	sudo apt-get update
	sudo apt-get install google-cloud-cli
else
	echo "google-cloud-cli already installed! Skipping..."
fi


# Install rust. See https://www.rust-lang.org/tools/install
is_installed rustup
if [ "false" = "$INSTALLED" ]
then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	rustup override set stable
	rustup update stable
else
	echo "rustup already installed! Skipping..."
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
# 	See https://github.com/alacritty/alacritty/issues/5564
is_installed brew
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
	#	Install requirements
	sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
	cargo build --release
	# 	Move to bin
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
if [ "true" = "$INSTALLED" ]
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

