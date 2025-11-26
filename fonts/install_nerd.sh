#!/bin/bash
#	Move to ~/.fonts/ so fonts will be seen by system
mkdir -p ~/.fonts/
cd ~/.fonts/
#	Get the source
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Monaspace.zip -o monaspice.zip
unzip monaspice.zip
# 	Cleanup
rm -f monaspice.zip
