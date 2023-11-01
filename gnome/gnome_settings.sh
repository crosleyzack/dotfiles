#!/bin/bash

# Enable fractional scaling
# gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"
