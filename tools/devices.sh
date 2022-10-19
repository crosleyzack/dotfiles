#!/bin/bash

# Remove battery saving on touchpad
ADDR=$(cat /proc/bus/input/devices | grep -i touchpad -A 2 | sed -n "s/^S: .*=\(.*\)$/\1/p")
echo on | sudo tee $ADDR
