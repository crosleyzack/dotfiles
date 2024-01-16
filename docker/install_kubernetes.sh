#!/bin/bash

echo "WARNING! If you are using nix, you don't want to install this! Backout now!"
sleep 10
echo "WARNING! Was not cancelled, continuing!"


source "${BASH_SOURCE%/*}/../tools/install_tools.sh"

# Install Kubernetes kubectl. See https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
is_installed kubectl
if [ "false" = "$INSTALLED" ]
then
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/   kubernetes.list
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

# Install Kubernetes helm. See https://helm.sh/docs/intro/install/#from-apt-debianubuntu
is_installed helm
if [ "false" = "$INSTALLED" ]
then
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    sudo apt-get install apt-transport-https --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/      sources.list.d/helm-stable-debian.list
    sudo apt-get update
    sudo apt-get install helm
fi

# Install Kubernetes kubectx. https://github.com/ahmetb/kubectx
is_installed kubectx
if [ "false" = "$INSTALLED" ]
then
    sudo apt install kubectx
    # sudo git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
    # sudo ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
    # sudo ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens
fi

# Install tilt: https://docs.tilt.dev/install.html#linux
is_installed tilt
if [ "false" = "$INSTALLED" ]
then
    curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
fi

# Install task: https://taskfile.dev/installation/#go-modules
is_installed tilt
if [ "false" = "$INSTALLED" ]
then
    go install github.com/go-task/task/v3/cmd/task@latest
fi

# https://cloud.google.com/sdk/docs/install#deb
is_installed google-cloud-cli
if [ "false" = "$INSTALLED" ]
then
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get update && sudo apt-get install google-cloud-cli
fi

# https://github.com/wagoodman/dive#installation
is_installed dive
if [ "false" = "$INSTALLED" ]
then
    export DIVE_VERSION=$(curl -sL "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
    curl -OL https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.deb
    sudo apt install ./dive_${DIVE_VERSION}_linux_amd64.deb
fi

is_installed cloud-sql-proxy
if [ "false" = "$INSTALLED" ]
then
    # Store in home directory and symlink
    mkdir -p $HOME/bin
    curl -o $HOME/bin/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.1/cloud-sql-proxy.linux.amd64
    chmod +x $HOME/cloud-sql-proxy
    sudo ln -s /$HOME/cloud-sql-proxy /usr/local/bin/cloud-sql-proxy
fi
