{ pkgs, ... }:

{
  programs = {
      tmux = {
          enable = true;
          keyMode = "vi";
          prefix = "C-w";
          baseIndex = 0;
          historyLimit = 1000000;
          shell = "${pkgs.zsh}/bin/zsh";
          terminal = "tmux-256color";
          plugins = with pkgs; [
            {
                plugin = tmuxPlugins.resurrect;
                extraConfig = ''
                    set -g @resurrect-strategy-vim 'session'
                    set -g @resurrect-capture-pane-contents 'on'
                    set -g @resurrect-save '!'
                    set -g @resurrect-restore '@'
                '';
            }
            {
                plugin = tmuxPlugins.continuum;
                extraConfig = ''
                    set -g @continuum-restore 'on'
                    set -g @continuum-boot 'on'
                    set -g @continuum-save-interval '10'
                '';
            }
            {
                plugin = tmuxPlugins.yank;
                extraConfig = ''
                    bind -T copy-mode-vi v send -X begin-selection
                    bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
                '';
            }
            {
                plugin = tmuxPlugins.tmux-nova;
                extraConfig = ''
                    set -g @plugin 'o0th/tmux-nova'
                    set -g @nova-nerdfonts true
                '';
            }
          ];
          extraConfig = ''
            set -g history-file "$HOME/.config/tmux/history"
            # remove unused bindings
            unbind '"'
            unbind %
            unbind c
            unbind &
            unbind !
            unbind @
            # add useful aliases
            set -s command-alias[6] "aliases=show-options command-alias"
            set -s command-alias[7] ns='new -s'
            set -s command-alias[8] rename='rename-session -t'
            set -s command-alias[9] default='attach -c'
            set -s command-alias[10] kill='kill-session -t'
            set -s command-alias[11] clean='for x in $(tmux list-sessions | grep -E -i "^[[:digit:]]" | awk -F ":" "{print \$1}"); do tmux kill-session -t $x; done'
            # remove delay reading command characters while awaiting escape sequence
            set -s escape-time 1
            # set vim style bindings
            bind ` source-file "$HOME/.config/tmux/tmux.conf" \; display "tmux reloaded"
            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R
            bind s split-window -h
            bind v split-window -v
            bind \; last-pane
            bind q kill-pane
            bind w select-pane -R
            bind W select-pane -L
            bind r swap-pane -U
            bind R swap-pane -D
            bind $ command-prompt -I'#W' { rename-session -- '%%' }
            bind , command-prompt -I'#W' { rename-window -- '%%' }
            bind - resize-pane -D 5
            bind + resize-pane -U 5
            bind \% resize-pane -y "50%"
            bind _ resize-pane -y "100%"
            bind < resize-pane -L 5
            bind > resize-pane -R 5
            bind ^ resize-pane -x "50%"
            bind | resize-pane -x "100%"
            bind = select-layout tiled
            bind K select-layout even-vertical
            bind J select-layout main-horizontal
            bind H select-layout even-horizontal
            bind L select-layout main-vertical
            bind ? previous-layout
            bind o kill-pane -a
            bind x swap-pane -D
            bind t select-pane -t "{top-left}"
            bind b select-pane -t "{bottom-right}"
            bind p switch-client -l
            bind \\ choose-session -Z
            bind " " set-option status
            bind-key * choose-window -F "#{window_index}: #{window_name}" "join-pane -v -t %%"
            bind [ copy-mode
            bind ] copy-mode -q
          '';
      };
  };
}
