#!/bin/bash

# Function to check if a package or command is installed.
# Will set $INSTALLED to "true" if found, "false" if not.
# $1 package name
function is_installed {
    if [ "" != "$(command -v $1)" ]
    then
            # If a command of this name exists, then it is installed.
            echo "Package $1 is installed!"
            INSTALLED="true"
    else
            echo "Package $1 NOT installed!"
            INSTALLED="false"
	fi
}
