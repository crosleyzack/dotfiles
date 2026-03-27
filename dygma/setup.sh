#!/bin/bash

################################################################################
# Bazecor (Dygma Keyboard Configurator) Installation Script
#
# Purpose:
#   Downloads and installs Bazecor, the configuration software for Dygma
#   keyboards (Raise, Defy). Creates a desktop entry for easy access.
#
# Behavior:
#   1. Downloads Bazecor v1.7.0 AppImage from GitHub releases
#   2. Extracts the AppImage to access its contents
#   3. Configures chrome-sandbox permissions for proper execution
#   4. Copies extracted files to ~/programs/bazecor
#   5. Creates a .desktop file for desktop environment integration
#   6. Symlinks the desktop file to ~/.local/share/applications
#   7. Updates the desktop database
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - curl (for downloading)
#   - Sudo privileges (for sandbox permissions and desktop database update)
#   - PolicyKit packages (optional, for better privilege management):
#     sudo apt-get install policykit-1-gnome policykit-1 libpolkit-agent-1-dev
#
# Installed To:
#   ~/programs/bazecor/
#
# Desktop Entry:
#   ~/.local/share/applications/bazecor.desktop
#
# DEPRECATED:
#   This script is deprecated. Use Nix package manager for installation instead.
################################################################################

echo "NOTE: now deprecated, use nix"

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
IMAGE="$TEMP/bazecor"
rm -f $IMAGE
#   Download to Temp
# Expected SHA256 for Bazecor v1.7.0
# Last verified: 2026-03-27
# Source: https://github.com/Dygmalab/Bazecor/releases/tag/v1.7.0
EXPECTED_SHA256="8bee840604fc16fdc6376ab09ebf901fd99c0d3a1e42f8ade76a91b77d18f6c3"
DOWNLOAD_URL="https://github.com/Dygmalab/Bazecor/releases/download/v1.7.0/Bazecor-1.7.0-x64.AppImage"

echo "Downloading Bazecor AppImage..."
if ! curl -fSL "$DOWNLOAD_URL" -o "$IMAGE"; then
    echo "Error: Failed to download Bazecor AppImage" >&2
    exit 1
fi

echo "Verifying SHA256 checksum..."
ACTUAL_SHA256=$(sha256sum "$IMAGE" | awk '{print $1}')

if [ "$ACTUAL_SHA256" != "$EXPECTED_SHA256" ]; then
    echo "Error: Checksum verification FAILED!" >&2
    echo "  Expected: $EXPECTED_SHA256" >&2
    echo "  Got:      $ACTUAL_SHA256" >&2
    echo "" >&2
    echo "The downloaded file may be corrupted or tampered with." >&2
    echo "DO NOT proceed unless you can verify the checksum is legitimate." >&2
    rm -f "$IMAGE"
    exit 1
fi
echo "✓ Checksum verified successfully"

chmod a+x $IMAGE
#   Extract image
cd $TEMP && ./image --appimage-extract
sudo chown root:root squashfs-root/chrome-sandbox
sudo chmod 4755 squashfs-root/chrome-sandbox
./squashfs-root/AppRun
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
