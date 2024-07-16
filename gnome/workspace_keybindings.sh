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
echo "Removing switch to application # keybindings"
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
echo "Set change workspace keybindings"
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
echo "Set move to workspace keybindings"
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

# Unbind applicaiton switch, set to cycle in workspace
echo "Set cycle within workspace binding"
dconf reset /org/gnome/desktop/wm/keybindings/switch-applications
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-applications-backward
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Super>Grave']"
dconf write /org/gnome/desktop/wm/keybindings/cycle-windows "['<Super>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/cycle-windows-backward "['<Super><Shift>Tab']"
dconf write /org/gnome/desktop/wm/keybindings/cycle-group "['<Super>a']"
dconf write /org/gnome/desktop/wm/keybindings/cycle-group-backward "['<Super><Shift>a']"

# Move to side
echo "Set move application to side keybindings"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-e "['<Super>l']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-n "['<Super>k']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-s "['<Super>j']"
dconf write /org/gnome/desktop/wm/keybindings/move-to-side-w "['<Super>h']"
dconf write /org/gnome/desktop/wm/keybindings/maximize-horizontally "['<Super>s']"
dconf write /org/gnome/desktop/wm/keybindings/maximize-vertically "['<Super>v']"

# Use vim bindings for maximize too
echo "Set maximize keybindings"
dconf reset /org/gnome/desktop/wm/keybindings/minimize
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>Grave']"
dconf write /org/gnome/desktop/wm/keybindings/maximize "['<Super>Up']"
dconf write /org/gnome/desktop/wm/keybindings/unmaximize "['<Super>Down']"
dconf write /org/gnome/desktop/wm/keybindings/toggle-fullscreen "['<Super>f']"

# Unbind move monitor
echo "Removing unnecessary bindings"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-workspace-left
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-workspace-right
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-workspace-last
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-workspace-up
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-to-workspace-down
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-workspace-left
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-workspace-right
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-workspace-last
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-workspace-up
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-up "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-workspace-down
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-down "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-left
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-left "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-right
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-right "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-up
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-up "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/move-to-monitor-down
gsettings set org.gnome.desktop.wm.keybindings move-to-monitor-down "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-group
gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-group-backward
gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-group-panels
gsettings set org.gnome.desktop.wm.keybindings switch-group-panels "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-group-panels-backward
gsettings set org.gnome.desktop.wm.keybindings switch-group-panels-backward "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-panels
gsettings set org.gnome.desktop.wm.keybindings switch-panels "['<Super>Grave']"
dconf reset /org/gnome/desktop/wm/keybindings/switch-panels-backward
gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward "['<Super>Grave']"

echo "Set other keybindings"

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
