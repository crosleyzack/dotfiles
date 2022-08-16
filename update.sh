#!/bin/bash

# Script to update machine fully

# Apt packages 
sudo apt update
sudo apt upgrade
sudo apt autoremove
sudo apt autoclean
sudo apt clean
# Update rust
rustup update
# Update brew
brew update
brew upgrade
# Update important python libs
python -m pip install --upgrade wheel pip setuptools virtualenv
