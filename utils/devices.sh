#!/bin/bash

################################################################################
# Touchpad Battery Saving Disable Script
#
# Purpose:
#   Disables power saving mode on the touchpad to prevent it from going into
#   low-power state, which can cause responsiveness issues.
#
# Behavior:
#   1. Searches /proc/bus/input/devices for the touchpad device
#   2. Extracts the sysfs path for the touchpad's power management
#   3. Writes 'on' to the power control file to disable power saving
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Sudo privileges (required to write to sysfs)
#   - Touchpad device must be present and detectable
#
# Note:
#   You may need to install additional Synaptics touchpad packages:
#   sudo apt install xserver-xorg-input-synaptics xserver-xorg-input-libinput
#                    xserver-xorg-input-evdev xserver-xorg-input-mouse
#   See: https://help.ubuntu.com/community/SynapticsTouchpad
################################################################################

# Remove battery saving on touchpad
ADDR=$(cat /proc/bus/input/devices | grep -i touchpad -A 2 | sed -n "s/^S: .*=\(.*\)$/\1/p")
echo on | sudo tee $ADDR