#!/bin/bash

if ! command -v go &> /dev/null
then
    echo "go could not be found"
    exit 1
fi

# install packages only available via go install
go install \
    github.com/crosleyzack/xplr@latest
