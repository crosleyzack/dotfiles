#!/bin/bash

# Install some apt packages
sudo apt update
sudo apt upgrade
sudo apt install -y \
    apt-transport-https \
    binutils \
    binwalk \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    curl \
    diffutils \
    gcc \
    gdb \
    gettext \
    git \
    gnupg \
    gzip \
    jq \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libpcsclite-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libtool \
    libtool-bin \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    lsb-release \
    make \
    miniupnpc \
    ncurses-base \
    net-tools \
    nmap \
    openssl \
    pipenv \
    python-is-python3 \
    python3 \
    tcpdump \
    tmux \
    unar \
    unzip \
    vim \
    wget \
    whois \
    wmctrl \
    xsel \
    xz-utils \
    zlib1g-dev \

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Setup pyenv
is_installed pyenv
if [ "false" = "$INSTALLED" ]
then
	# TODO better to brew install?
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PATH:$PYENV_ROOT/bin"
	# NOTE make sure to regularly `git pull` to update.
	# Install pyenv-virtualenv
	git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
fi

# Setup poetry
is_installed poetry
if [ "false" = "$INSTALLED" ]
then
    curl -sSL https://install.python-poetry.org | python3 -
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
else
    echo "Zsh already installed, skipping..."
fi

# Setup docker. See https://docs.docker.com/engine/install/ubuntu/
is_installed docker-ce
if [ "false" = "$INSTALLED" ]
then
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    # Add the repository to Apt sources:
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd -f docker
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "docker-ce already installed! Skipping"
fi

# Setup firefox. See https://support.mozilla.org/en-US/kb/install-firefox-linux
is_installed firefox
if [ "false" = "$INSTALLED" ]
then
    sudo rm -rf /opt/firefox
    sudo mkdir -p /opt
    mkdir -p $HOME/temp
    curl -L -o $HOME/temp/firefox.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
    cd $HOME/temp && tar xjf firefox.bz2
    sudo cp -r $HOME/temp/firefox /opt
    rm $HOME/temp/firefox.bz2
    sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
else
    echo "firefox already installed! Skipping"
fi


