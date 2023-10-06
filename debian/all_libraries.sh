#!/bin/bash

# Install some apt packages
sudo apt update
sudo apt upgrade
sudo apt install -y tmux \
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
	git-gui \
	apt-transport-https \
	texlive-latex-extra \
	texlive-fonts-extra \
	vim \
	fonts-powerline \
	postgresql-client \
    python3 \
	python-is-python3 \
	pipenv \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	wget \
	llvm \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libxml2-dev \
	libxmlsec1-dev \
	libffi-dev \
	liblzma-dev \
	libpcsclite-dev \
	xsel \
	miniupnpc \
	net-tools \
    ranger \
    simple-scan \
    whois \
    rdesktop \
    libtool \
    libtool-bin \
    gettext \
    binwalk \
    unar \
    miniupnpc \
    net-tools

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Setup golang
is_installed golang
if [ "false" = "$INSTALLED" ]
then
	sudo apt install golang-go
	export GO_PATH="$HOME/go"
	export GOPATH="$HOME/go"
	export PATH="$PATH:$GOPATH/bin"
fi

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

# Install yubikey agent.
is_installed yubikey-agent
if [ "false" = "$INSTALLED" ]
then
	mkdir ~/temp
	cd ~/temp
	git clone https://filippo.io/yubikey-agent && cd yubikey-agent
	go build && sudo cp yubikey-agent /usr/local/bin/
	yubikey-agent -setup
	curl https://raw.githubusercontent.com/FiloSottile/yubikey-agent/main/contrib/systemd/user/yubikey-agent.service > ~/.config/systemd/user/yubikey-agent.service
	systemctl daemon-reload --user
	sudo systemctl enable --now pcscd.socket
	systemctl --user enable --now yubikey-agent
	export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/yubikey-agent/yubikey-agent.sock"
else
	echo "yubikey-agent already installed! Skipping"
fi



# Setup google cloud CLI. See https://cloud.google.com/sdk/docs/install
is_installed google-cloud-cli
if [ "false" = "$INSTALLED" ]
then
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	sudo apt-get update
	sudo apt-get install google-cloud-cli google-cloud-sdk-gke-gcloud-auth-plugin
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

# Install cloud_sql_proxy. See https://cloud.google.com/sql/docs/mysql/connect-auth-proxy#install
is_installed cloud_sql_proxy
if [ "false" = "$INSTALLED" ]
then
	wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
	chmod +x cloud_sql_proxy
	sudo mv cloud_sql_proxy /usr/bin/
fi

# Install nodejs. See https://nodejs.org/en/download/package-manager/
is_installed node
if [ "false" = "$INSTALLED" ]
then
	# TODO install via NVM to prevent permissions issues
	curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
	sudo apt-get install -y nodejs
	# install node packages
	npm install yarn
	npm install jest
fi

# Install spanner-cli. See https://github.com/cloudspannerecosystem/spanner-cli#install
is_installed spanner-cli
if [ "false" = "$INSTALLED" ]
then
	go install github.com/cloudspannerecosystem/spanner-cli@latest
fi

# Install gitlab-runner. See https://docs.gitlab.com/runner/install/
is_installed gitlab-runner
if [ "false" = "$INSTALLED" ]
then
	curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
	sudo apt-get update
	sudo apt-get install gitlab-runner
fi

# Install Kubernetes kubectx. https://github.com/ahmetb/kubectx
is_installed kubectx
if [ "false" = "$INSTALLED" ]
then
	sudo git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
	sudo ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
	sudo ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

# Install grpcurl. See https://github.com/fullstorydev/grpcurl#installation
is_installed grpcurl
if [ "false" = "$INSTALLED" ]
then
	go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
fi

# Install protobuf. See https://grpc.io/docs/protoc-installation/
is_installed protobuf-compiler
if [ "false" = "$INSTALLED" ]
then
	sudo apt install protobuf-compiler
	# NOTE: DO NOT INSTALL golang-goprotobuf-dev
	#	instead, install libraries via:
	#		go get <your library name>
	# HINT: most projects will install necessary things in their make file
fi

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

# Install Kubernetes kubectl. See https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
is_installed kubectl
if [ "false" = "$INSTALLED" ]
then
	sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
	sudo apt-get update
	sudo apt-get install -y kubectl
fi

# Install Kubernetes kind. See https://kind.sigs.k8s.io/
is_installed kind
if [ "false" = "$INSTALLED" ]
then
	go install sigs.k8s.io/kind@v0.17.0
	# Make sure go in path. Should already be true
	# export PATH=$PATH:$($(go env GOPATH)/bin)
fi

# Install Kubernetes ctlptl. See https://github.com/tilt-dev/ctlptl/blob/main/INSTALL.md
is_installed ctlptl
if [ "false" = "$INSTALLED" ]
then
	go install github.com/tilt-dev/ctlptl/cmd/ctlptl@latest
	# Make sure go in path. Should already be true
	# export PATH=$PATH:$($(go env GOPATH)/bin)
fi

# Install Kubernetes helm. See https://helm.sh/docs/intro/install/
is_installed helm
if [ "false" = "$INSTALLED" ]
then
	curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
	sudo apt-get install apt-transport-https --yes
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	sudo apt-get update
	sudo apt-get install helm
fi

# Install Yubikey Manager. See https://docs.yubico.com/software/yubikey/tools/ykman/Install_ykman.html
is_installed ykman
if [ "false" = "$INSTALLED" ]
then
    sudo apt-add-repository ppa:yubico/stable
    sudo apt update
    sudo apt install yubikey-manager
fi

# Install spotify.
is_installed spotify
if [ "false" = "$INSTALLED" ]
then
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
 #   sudo snap install slack
 # NOTE non-snap version has issues: https://github.com/Foundry376/Mailspring/issues/2154
 mkdir ~/temp
 cd ~/temp
 wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.0.2-amd64.deb
 sudo apt install ./slack-desktop-*.deb
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
    # install extensions
    cd "${CONFIG}" && ./Code/extensions/install-extensions.sh
else
    echo "VS Code already installed! Skipping..."
fi

# Install Brew. See https://brew.sh
is_installed brew
if [ "false" = "$INSTALLED" ]
then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    touch $HOME/.zprofile
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zprofile
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
else
    echo "Zsh already installed, skipping..."
fi

# Install redis-cli
is_installed redis-cli
if [ "false" = "$INSTALLED" ]
then
    curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list
    sudo apt-get update
    sudo apt-get install redis
else
    echo "Redis already installed, skipping..."
fi

# Install neovim
is_installed nvim
if [ "false" = "$INSTALLED" ]
then
    # Build nvim from source so we can get exact version we want
    mkdir -p $HOME/programs
    sudo rm -rf $HOME/programs/neovim
    git clone https://github.com/neovim/neovim $HOME/programs/neovim
    cd $HOME/programs/neovim && git checkout 'release-0.8' && sudo make install
else
    echo "Nvim already installed, skipping"
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


