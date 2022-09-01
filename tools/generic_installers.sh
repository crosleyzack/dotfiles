#!/bin/bash 

# Function to check if a package or command is installed.
# Will set $INSTALLED to "true" if found, "false" if not.
# $1 package name
function is_installed {
        if [ "install ok installed" = "$(dpkg-query -W --showformat='${Status}\n' $1 | grep 'install ok installed')" ]
        then
                # If we find the name in dpkg, then it is installed.
                echo "Package $1 is installed!"
                INSTALLED="true"
        elif [ "" != $(command -v $1) ]
        then
                # If a command of this name exists, then it is installed.
                echo "Package $1 is installed!"
                INSTALLED="true"
        else
                echo "Package $1 NOT installed!"
                INSTALLED="false"
        fi
}


# get a git repo from url of form: https://domain.com/some/file/path/repo.git and store in ~/temp/repo-name
# $1 = url git path
function get_git {
	NAME=$(echo $1 | awk '{n=split($1,a,"/"); print a[n]}' | awk '{split($1,a,"."); print a[1]}')
	mkdir $HOME/temp
	git clone $1 $HOME/temp/$NAME
}


# Install Proxychains
is_installed proxychains
if [ "false" = "$INSTALLED" ]
then
	get_git https://github.com/haad/proxychains.git
	cd $HOME/temp/proxychains && ./configure && make && sudo make install
else
        echo "Proxychains already installed! Skipping..."
fi

