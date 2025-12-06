{ pkgs, ... }:

{
  home.shell.enableZshIntegration = true;
  home.shell.enableBashIntegration = true;

  # setup cli programs
  programs = {
      bash = {
          enable = true;
          historyFile = "~/bash_record";
          sessionVariables = {
              MOZ_ENABLE_WAYLAND = 1;
          };
          # ensure nix and go packages are available in shell
          bashrcExtra = ''
            source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
            source $HOME/.nix-profile/etc/profile.d/nix.sh
            export PATH="$PATH:$HOME/go/bin"
          '';
      };
      vim = {
          enable = true;
          defaultEditor = true;
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
      direnv = {
          enable = true;
          enableZshIntegration = true;
          # TODO investigate this later
          nix-direnv.enable = false;
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
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          # vim commands in command line
          defaultKeymap = "viins";
          envExtra = ''
            export MOZ_ENABLE_WAYLAND=1
            export EDITOR='vim'
            export USE_GKE_GCLOUD_AUTH_PLUGIN=true
            export OUTSIDE_DOCKER_HOST="172.17.0.1"
         '';
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
            export PATH="$PATH:$HOME/go/bin"
          '';
      };
  };
}

