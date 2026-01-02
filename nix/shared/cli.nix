{ pkgs, ... }:

{
  home.shell.enableZshIntegration = true;
  home.shell.enableBashIntegration = true;

  # setup cli programs
  programs = {
      bash = {
          enable = true;
          historyFile = "$HOME/bash_record";
          sessionVariables = {
              MOZ_ENABLE_WAYLAND = 1;
          };
          # ensure nix and go packages are available in shell
          bashrcExtra = ''
            source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
            source $HOME/.nix-profile/etc/profile.d/nix.sh
          '';
      };
      vim = {
          enable = true;
          defaultEditor = true;
          extraConfig = ''
            set so=7
            set ruler
            set cmdheight=1
            set hid
            set whichwrap+=<,>,h,l
            set ignorecase
            set smartcase
            set hlsearch
            set incsearch
            set lazyredraw
            set magic
            set showmatch
            set mat=2
            set noerrorbells
            set novisualbell
            set t_vb=
            set tm=500
            syntax enable
            set regexpengine=0
            set background=dark
            set encoding=utf8
            set ffs=unix,dos,mac
            set nobackup
            set nowb
            set noswapfile
            set nocompatible
            set expandtab
            set smarttab
            set shiftwidth=4
            set tabstop=4 softtabstop=0
            set lbr
            set tw=500
            set laststatus=2
          '';
          settings = {
              relativenumber = true;
          };
      };
      atuin = {
          enable = true;
          enableZshIntegration = true;
          settings = {
              style = "compact";
              search_mode = "fuzzy";
          };
      };
      dircolors = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };
      direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
      };
      starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
              format = "$all";
              battery.disabled = true;
          };
      };
      zsh = {
          enable = true;
          enableCompletion = true;
          autosuggestion = {
            enable = true;
            strategy = [
              "history"
            ];
          };
          syntaxHighlighting = {
            enable = true;
            highlighters = [
              "main"
              "brackets"
            ];
          };
          # vim commands in command line
          defaultKeymap = "viins";
          envExtra = ''
            export USE_GKE_GCLOUD_AUTH_PLUGIN=true
            export OUTSIDE_DOCKER_HOST="172.17.0.1"
          '';
          setOptions = [
            "NO_BEEP"
            "INC_APPEND_HISTORY"
          ];
          history.path = "$HOME/.zsh_record";
          shellAliases = {
              devbox = "toolbox run -c devs tmux";
          };
          # ensure nix and go packages are available in shell
          completionInit = ''
            autoload -Uz compinit && compinit
            autoload -U +X bashcompinit && bashcompinit
            source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
            source $HOME/.nix-profile/etc/profile.d/nix.sh
            test -f $HOME/.env && source $HOME/.env 
          '';
      };
  };
}

