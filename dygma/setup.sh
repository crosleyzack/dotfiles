#!/bin/bash

# Install requirements
#   sudo apt-get install policykit-1-gnome policykit-1 libpolkit-agent-1-dev
# Download AppImage
#   Initialize empty directories
PROGRAMS="$HOME/programs"
BAZECOR="$PROGRAMS/bazecor"
EXE="$BAZECOR/AppRun"
TEMP="$HOME/TEMP"
IMAGE="$TEMP/image"
# LOC="$HOME/.local/share/applications/"
LOC="/usr/local/share/applications/"
mkdir -p $PROGRAMS
mkdir -p $LOC
mkdir -p $TEMP
rm -rf "$BAZECOR/bazecor"
mkdir -p $BAZECOR
#   Download to Temp
curl -L https://github.com/Dygmalab/Bazecor/releases/download/v1.3.9/Bazecor-1.3.9-x64.AppImage -o $IMAGE
chmod a+x $IMAGE
#   Extract image
cd $TEMP && ./image --appimage-extract
#   Copy to final location
cp -a squashfs-root/. $BAZECOR
# Create Desktop Entry
sudo rm -f $LOC/bazecor.desktop
echo "linking to $BAZECOR/Bazecor.desktop from $LOC/bazecor.desktop"
sudo ln -s $BAZECOR/Bazecor.desktop $LOC/bazecor.desktop
# sudo ln -s $LOC/bazecor.desktop $BAZECOR/Bazecor.desktop
# DESKTOP="$HOME/Desktop"
# LINK="$LOC/bazecor.desktop"
# rm -f $LINK
# echo "[Desktop Entry]
# Encoding=UTF-8
# Terminal=0
# Exec=$EXE
# Type=Application
# Categories=Graphics;
# StartupNotify=true
# Name=Bazecor
# GenericName=Bazecor" > $LINK
# chmod a+x $LINK
sudo update-desktop-database
