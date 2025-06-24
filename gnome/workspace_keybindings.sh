#!/bin/bash

TERMINAL="gnome-terminal"

# We need to set a fixed number of workspaces for this to work.
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 10

# Remove the hotkeys already bound to super + num.
#	set hotkeys to false
dconf reset /org/gnome/shell/extensions/dash-to-dock/hot-keys
# gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false
# View dconf keybindings:
#    dconf dump /org/gnome/desktop/wm/keybindings/
#	remove mapping
#	org.gnome.shell.keybindings switch-to-application-1 ['<Super>1']

# remove existing bindings
declare -a keys=("<Super>1" "<Super>2" "<Super>3" "<Super>4" "<Super>5" "<Super>6" "<Super>7" "<Super>8" "<Super>9" "<Super>0" "<Super><Shift>1" "<Super><Shift>2" "<Super><Shift>3" "<Super><Shift>4" "<Super><Shift>5" "<Super><Shift>6" "<Super><Shift>7" "<Super><Shift>8" "<Super><Shift>9" "<Super><Shift>0" "<Super>Tab" "<Super><Shift>Tab" "<Super>a" "<Super><Shift>a" "<Super>l" "<Super>k" "<Super>j" "<Super>h" "<Super>s" "<Super>v" "<Super>Up" "<Super>Down" "<Super>z" "<Super>Return")
printf '%s\n' "${keys[@]}"
## remove all keybdings
for k in "${keys[@]}"
do
    echo "Key=$k"
    bindings=()
    mapfile -t bindings < <( gsettings list-recursively | grep "'$k'" )
    echo "Matches=$bindings"
    for b in "${bindings[@]}"
    do
        schema=$(echo $b | cut -d ' ' -f 1)
        command=$(echo $b | cut -d ' ' -f 2)
        echo "unbinding $schema $command"
        gsettings set $schema $command "['Grave']"
    done
done

# Set super + num goes to workspace num.
echo "Set change workspace keybindings"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

# Set super + shift + num moves a window to workspace num.
echo "Set move to workspace keybindings"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-1  "['<Super><Shift>1']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-2  "['<Super><Shift>2']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-3  "['<Super><Shift>3']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-4  "['<Super><Shift>4']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-5  "['<Super><Shift>5']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-6  "['<Super><Shift>6']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-7  "['<Super><Shift>7']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-8  "['<Super><Shift>8']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-9  "['<Super><Shift>9']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-10 "['<Super><Shift>0']"

# Unbind applicaiton switch, set to cycle in workspace
echo "Set cycle within workspace binding"
gsettings set org.gnome.desktop.wm.keybindings cycle-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "['<Super><Shift>Tab']"
gsettings set org.gnome.desktop.wm.keybindings cycle-group "['<Super>a']"
gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "['<Super><Shift>a']"

# Move to side
echo "Set move application to side keybindings"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-e "['<Super>l']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-n "['<Super>k']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-s "['<Super>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-side-w "['<Super>h']"
gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Super>s']"
gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Super>v']"

# Use vim bindings for maximize too
echo "Set maximize keybindings"
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

# Unbind move monitor
echo "Removing unnecessary bindings"
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
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/ command $TERMINAL
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom/ binding '<Super>Return'

echo "Set terminal open keybindings"

# Enable fractional scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
# gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling']"

echo "Set fractional scaling"
