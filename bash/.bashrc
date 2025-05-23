# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Make sure aliases don't run inside toolbx container
if [[ -f /run/.toolboxenv ]]; then
    toolbx_exports=(
        podman
        flatpak
        gsettings
        xrandr
        wmctrl
        pgrep
        dconf
        rpm-ostree
    )

    for cmd in "${toolbx_exports[@]}"; do
        alias "${cmd}"="flatpak-spawn --host ${cmd} $*"
    done
    unset cmd toolbx_exports
fi

export HISTFILE="~/.bash_record"
export MOZ_ENABLE_WAYLAND=1
