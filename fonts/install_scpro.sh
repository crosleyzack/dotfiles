#!/bin/bash
sudo apt install -y \
    wget \
    unzip

#	Move to ~/.fonts/ so fonts will be seen by system
mkdir -p ~/.fonts/
cd ~/.fonts/
#	Get the source
wget https://github.com/adobe-fonts/source-code-pro/releases/download/2.038R-ro%2F1.058R-it%2F1.018R-VAR/OTF-source-code-pro-2.038R-ro-1.058R-it.zip
unzip OTF-source-code-pro-2.038R-ro-1.058R-it.zip
# 	Cleanup
rm -f OTF-source-code-pro-2.038R-ro-1.058R-it.zip
rm -rf __MACOSX
rm -f LICENSE.md
