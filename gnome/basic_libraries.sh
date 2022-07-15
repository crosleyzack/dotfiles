#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install tmux \
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
	vim


# Setup docker. See https://docs.docker.com/engine/install/ubuntu/
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Setup google cloud CLI. See https://cloud.google.com/sdk/docs/install
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update
sudo apt-get install google-cloud-cli
