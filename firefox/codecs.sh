#!/bin/sh

################################################################################
# Firefox Multimedia Codec Installation Script (Fedora)
#
# Purpose:
#   Installs multimedia codecs and hardware acceleration drivers for Firefox
#   on Fedora-based systems by configuring RPM Fusion repositories.
#
# Behavior:
#   1. Adds RPM Fusion free and nonfree repositories
#   2. Enables Fedora's Cisco OpenH264 repository
#   3. Replaces ffmpeg-free with full ffmpeg
#   4. Installs multimedia codec group packages
#   5. Installs sound and video group packages
#   6. Replaces Mesa VA-API and VDPAU drivers with freeworld versions
#      for better hardware acceleration support
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Fedora-based Linux distribution
#   - dnf package manager
#   - Sudo privileges
#
# Reference:
#   https://rpmfusion.org/Configuration
################################################################################

# https://rpmfusion.org/Configuration
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager --enable fedora-cisco-openh264
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf groupupdate multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
