#!/bin/bash

# Ensure dotfiles repo is defined
if [ ! -f "$1" ]
then
    echo "\$1 must be json file"
    exit 1
fi

# create each session defined
while read session
do
    name=$(echo "$session" | jq -r .name)
    path=$(echo "$session" | jq -r .path)
    echo "Creating session $name at $path"
    tmux new -s $name -c $path -d
done < <( cat $1 | jq -c ".sessions[]" )

