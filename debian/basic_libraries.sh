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
    printer-driver-all

# Update python
python -m pip install --upgrade pip wheel setuptools virtualenv

source "${BASH_SOURCE%/*}/../python/install_python.sh"
source "${BASH_SOURCE%/*}/../debian/install_firefox.sh"
source "${BASH_SOURCE%/*}/../zsh/zsh_setup.sh"
source "${BASH_SOURCE%/*}/../alacritty/install_alacritty.sh"
source "${BASH_SOURCE%/*}/../docker/install_docker.sh"
