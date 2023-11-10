#!/bin/bash

echo "WARNING! If you are using nix, you don't want to install this! Backout now!"
sleep 10
echo "WARNING! Was not cancelled, continuing!"

source "${BASH_SOURCE%/*}/basic_libraries.sh"

# Install some apt packages
sudo apt update
sudo apt upgrade
sudo apt install -y \
    cups \
    fonts-powerline \
    git-lfs \
    postgresql-client \
    ranger \
    rdesktop \
    simple-scan \
    tk-dev

# Setup golang
is_installed golang
if [ "false" = "$INSTALLED" ]
then
	sudo apt install golang-go
	export GO_PATH="$HOME/go"
	export GOPATH="$HOME/go"
	export PATH="$PATH:$GOPATH/bin"
fi

# Setup golang
is_installed tex
if [ "false" = "$INSTALLED" ]
then
    sudo apt-get install texlive-fonts-extra texlive-latex-extra
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
    # NOTE: if it stops working, restart with
    # systemctl --user restart yubikey-agent
else
	echo "yubikey-agent already installed! Skipping"
fi

# Install Yubikey Manager. See https://docs.yubico.com/software/yubikey/tools/ykman/Install_ykman.html
is_installed ykman
if [ "false" = "$INSTALLED" ]
then
    sudo apt-add-repository ppa:yubico/stable
    sudo apt update
    sudo apt install yubikey-manager
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

source "${BASH_SOURCE%/*}/../docker/install_kubernetes.sh"
source "${BASH_SOURCE%/*}/../proxychains/install_proxychains.sh"
