#!/bin/bash

mkdir -p $HOME/temp
rm -f $HOME/temp/zoom.deb
curl -SL -o $HOME/temp/zoom.deb https://zoom.us/client/5.16.2.8828/zoom_amd64.deb
sudo apt install $HOME/temp/zoom.deb
