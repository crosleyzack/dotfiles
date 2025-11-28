#!/bin/bash

# Remove battery saving on touchpad
ADDR=$(cat /proc/bus/input/devices | grep -i touchpad -A 2 | sed -n "s/^S: .*=\(.*\)$/\1/p")
echo on | sudo tee $ADDR

# Potential required installs for setting touchpad sensititive. See:
#	https://help.ubuntu.com/community/SynapticsTouchpad
# sudo apt install xserver-xorg-input-synaptics xserver-xorg-input-libinput xserver-xorg-input-evdev xserver-xorg-input-mouse
