#!/bin/bash

# We need to set a fixed number of workspaces for this to work.
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 10

echo "Set workspaces to 10"

# Remove the hotkeys already bound to super + num.
#	set hotkeys to false
dconf reset /org/gnome/shell/extensions/dash-to-dock/hot-keys
# gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
# View dconf keybindings:
#    dconf dump /org/gnome/desktop/wm/keybindings/
#	remove mapping
#	org.gnome.shell.keybindings switch-to-application-1 ['<Super>1']
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-1
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-2
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-3
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-4
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-5
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-6
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-7
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-8
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-9
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-application-10
# gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Super>Grave']"

# Set super + num goes to workspace num.
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-1 "['<Super>1']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-2 "['<Super>2']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-3 "['<Super>3']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-4 "['<Super>4']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-5 "['<Super>5']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-6 "['<Super>6']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-7 "['<Super>7']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-8 "['<Super>8']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-9 "['<Super>9']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-10 "['<Super>0']"

# Set super + shift + num moves a window to workspace num.
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-1  "['<Super><Shift>1']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-2  "['<Super><Shift>2']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-3  "['<Super><Shift>3']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-4  "['<Super><Shift>4']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-5  "['<Super><Shift>5']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-6  "['<Super><Shift>6']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-7  "['<Super><Shift>7']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-8  "['<Super><Shift>8']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-9  "['<Super><Shift>9']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-10 "['<Super><Shift>0']"

echo "Set workspace keyboard shortcuts"

# Use vim bindings for maximize too
dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>Up','<Super>k']"
dconf write /org/gnome/desktop/wm/keybindings/minimize "['<Super><Shift>Down','<Super><Shift>j']"
dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>Down', '<Super>j']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-fullscreen "['<Super>z']"

# Unbind move monitor
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-left
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-right
# Move to adjacent workspaces
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-left "['<Super><Shift>h','<Super><Shift>Left']"
dconf write /org/gnome/desktop/wm/keybindings/switch-to-workspace-right "['<Super><Shift>l','<Super><Shift>Right']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-left "['<Super><Shift><Alt>h','<Super><Shift><Alt>Left']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-workspace-right "['<Super><Shift><Alt>l','<Super><Shift><Alt>Right']"

echo "Set other keybindings"

#
# org.gnome.desktop.default-applications.terminal exec 'x-terminal-emulator'
# org.gnome.desktop.default-applications.terminal exec-arg '-e'
# TODO Set super + enter to open terminal.
gsettings reset org.gnome.settings-daemon.plugins.media-keys terminal
gsettings reset org.gnome.settings-daemon.plugins.media-keys custom-keybindings
# NOTE: currently, this results in errors in Settings-Daemon mediaKeys at startup
gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>Return']"
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/ name terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/ command alacritty
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/ binding '<Super>Return'

echo "Set terminal open keybindings"

# Enable fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
# gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"

echo "Set fractional scaling"
