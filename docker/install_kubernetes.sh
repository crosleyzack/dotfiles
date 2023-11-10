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

# Install Kubernetes helm. See https://helm.sh/docs/intro/install/
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
    sudo git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
    sudo ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens
fi
