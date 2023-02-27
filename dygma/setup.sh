#!/bin/bash

# Download AppImage
#   Initialize empty directories
PROGRAMS="$HOME/programs"
BAZECOR="$PROGRAMS/bazecor"
TEMP="$HOME/TEMP"
IMAGE="$TEMP/image"
mkdir -p $PROGRAMS
mkdir -p $TEMP
rm -rf "$BAZECOR/bazecor"
mkdir -p $BAZECOR
#   Download to Temp
curl -L https://github.com/Dygmalab/Bazecor/releases/download/bazecor-1.0.0/Bazecor-1.0.0.AppImage -o $IMAGE
chmod a+x $IMAGE
#   Extract image
cd $TEMP && ./image --appimage-extract
#   Copy to final location
cp -a squashfs-root/. $BAZECOR
# Create Desktop Entry
DESKTOP="$HOME/Desktop"
LINK="$DESKTOP/bazecor.desktop"
rm -f $LINK
echo "[Desktop Entry]
Encoding=UTF-8
Terminal=0
Exec=$BAZECOR/bazecor
Type=Application
Categories=Graphics;
StartupNotify=true
Name=Bazecor
GenericName=Bazecor" >> $LINK
chmod a+x $LINK
