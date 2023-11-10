#!/bin/bash

source "${BASH_SOURCE%/*}/install_tools.sh"

# install metasploit
is_installed msfconsole
if [ "false" = "$INSTALLED" ]
then
	mkdir $HOME/temp
	curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > $HOME/temp/msfinstall && \
	chmod 755 $HOME/temp/msfinstall && \
	$HOME/temp/msfinstall
else
	echo "Metasploit is already installed! skipping..."
fi

