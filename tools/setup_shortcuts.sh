#!/bin/bash

# Slack
wget https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Slack_icon_2019.svg/480px-Slack_icon_2019.svg.png -O $HOME/Pictures/slack.png
sudo rm -f /usr/share/applications/slack.desktop
echo "[Desktop Entry]
Type=Application
Name=Slack
Exec=$(which slack)
Comment=Executes Slack
Icon=/home/crosley/Pictures/slack.png" | sudo tee -a /usr/share/applications/slack.desktop

# Spotify
wget https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Spotify_icon.svg/465px-Spotify_icon.svg.png -O $HOME/Pictures/spotify.png
sudo rm -f /usr/share/applications/spotify.desktop
echo "[Desktop Entry]
Type=Application
Name=Spotify
Exec=$(which spotify)
Comment=Executes Spotify
Icon=/home/crosley/Pictures/spotify.png" | sudo tee -a /usr/share/applications/spotify.desktop

# Signal
wget https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Signal-Logo.svg/480px-Signal-Logo.svg.png -O $HOME/Pictures/signal.png
sudo rm -f /usr/share/applications/signal.desktop
echo "[Desktop Entry]
Type=Application
Name=Signal
Exec=$(which signal)
Comment=Executes Signal
Icon=/home/crosley/Pictures/signal.png" | sudo tee -a /usr/share/applications/signal.desktop

# Zoom
wget https://assets.stickpng.com/images/5e8ce318664eae0004085461.png -O $HOME/Pictures/zoom.png
sudo rm -f /usr/share/applications/zoom.desktop
echo "[Desktop Entry]
Type=Application
Name=Zoom
Exec=$(which zoom)
Comment=Executes Zoom
Icon=/home/crosley/Pictures/zoom.png" | sudo tee -a /usr/share/applications/zoom.desktop

