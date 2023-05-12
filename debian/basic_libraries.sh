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
	python-is-python3 \
	pipenv \
	python3.10-venv \
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
    ranger

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

# Setup poetry.
# curl -sSL https://install.python-poetry.org | POETRY_HOME=$HOME/.poetry python - --git https://github.com/python-poetry/poetry.git@master

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
