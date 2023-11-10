#!/bin/bash

PACKAGE_NAME="$1"
OUT_DIR="$2"

# Ensure package is defined
if [ -z "$PACKAGE_NAME" ]
then
    echo "\$1 must be package name, not $1"
    exit 1
fi

# Ensure package is defined
if [ ! -d "$OUT_DIR" ]
then
    echo "\$2 must be output directory, not $2"
    echo "You probably want /usr/share/applications"
    exit 1
fi

SYM_LINK=$(which $PACKAGE_NAME)
PACKAGE=$(realpath $SYM_LINK)
PACKAGE_DIR=$(dirname "$PACKAGE")
# ICON_DIR="$PACKAGE_DIR/icons/hicolor/512x512"
ICON=$(find $PACKAGE_DIR -name "*.png" | head -1)
echo "Found icon $ICON for $PACKAGE_NAME"
# ICON=$(find $ICON_DIR | grep $1 | head -1)

TARGET_FILE="$OUT_DIR/$PACKAGE_NAME.desktop"
sudo rm -f $TARGET_FILE

echo "Creating desktop entry $TARGET_FILE"

echo "[Desktop Entry]
Type=Application
Name=$PACKAGE_NAME
Exec=$SYM_LINK
Comment=Executes $PACKAGE_NAME
Icon=$ICON" | sudo tee $TARGET_FILE

echo "DONE!"
