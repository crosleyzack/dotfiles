{ pkgs, ... }:

{
  home.shell.enableZshIntegration = true;

  programs = {
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

