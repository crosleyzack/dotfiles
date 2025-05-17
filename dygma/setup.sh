#!/bin/bash

# Install requirements
#   sudo apt-get install policykit-1-gnome policykit-1 libpolkit-agent-1-dev
# Download AppImage
#   Initialize empty directories
PROGRAMS="$HOME/programs"
mkdir -p $PROGRAMS
LOC="$HOME/.local/share/applications/"
mkdir -p $LOC
BAZECOR="$PROGRAMS/bazecor"
rm -rf "$BAZECOR"
mkdir -p $BAZECOR
TEMP="$HOME/TEMP"
mkdir -p $TEMP
IMAGE="$TEMP/image"
rm -f $IMAGE
#   Download to Temp
curl -L https://github.com/Dygmalab/Bazecor/releases/download/v1.6.5/Bazecor-1.6.5-x64.AppImage -o $IMAGE
# https://github.com/Dygmalab/Bazecor/releases/download/v1.7.0/Bazecor-1.7.0-x64.AppImage -o $IMAGE
chmod a+x $IMAGE
#   Extract image
cd $TEMP && ./image --appimage-extract
#   Copy to final location
cp -a squashfs-root/. $BAZECOR
# Create Desktop Entry
sudo rm -f $LOC/bazecor.desktop
echo "linking to $BAZECOR/Bazecor.desktop from $LOC/bazecor.desktop"
sudo ln -s $BAZECOR/bazecor.desktop $LOC/bazecor.desktop

rm -f $BAZECOR/bazecor.desktop
echo "[Desktop Entry]
Encoding=UTF-8
Terminal=0
Exec=AppRun
Type=Application
Categories=Graphics;
StartupNotify=true
Name=Bazecor
Path=$BAZECOR
Icon=$BAZECOR/bazecor.png
GenericName=Bazecor" > $BAZECOR/bazecor.desktop
chmod a+x $BAZECOR/AppRun
sudo update-desktop-database
