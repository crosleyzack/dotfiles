# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
# if ! [[ "$PATH" =~ "$(go env GOPATH)" ]]; then
#    PATH="$(go env GOPATH)/bin:$PATH"
# fi
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

export HISTFILE="~/.bash_record"
export MOZ_ENABLE_WAYLAND=1

[ -f "/etc/profile.d/nix.sh" ] && source "/etc/profile.d/nix.sh"
[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source "$HOME/.nix-profile/etc/profile.d/nix.sh"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh;

if [ -d $HOME/.atuin/bin ]; then
   eval "$(atuin init zsh)"
fi;
