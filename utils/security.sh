#!/bin/sh

# default all files to only editable by owner
umask 022

# allow outgoing connections but not incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Create a new sudoers configuration file
echo 'Defaults timestamp_timeout=1' | sudo tee /etc/sudoers.d/timeout
sudo chmod 0440 /etc/sudoers.d/timeout
sudo visudo -c

