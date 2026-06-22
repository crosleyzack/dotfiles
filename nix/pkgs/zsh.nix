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
            export HISTIGNORE="*token*:*password*:*secret*:*api*key*"
            # for pyenv to work on nix
            PYENV_ROOT="$HOME/.pyenv";
            CPPFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
            CXXFLAGS="-I${pkgs.zlib.dev}/include -I${pkgs.libffi.dev}/include -I${pkgs.readline.dev}/include -I${pkgs.bzip2.dev}/include -I${pkgs.openssl.dev}/include";
            CFLAGS="-I${pkgs.openssl.dev}/include";
            LDFLAGS="-L${pkgs.zlib.out}/lib -L${pkgs.libffi.out}/lib -L${pkgs.readline.out}/lib -L${pkgs.bzip2.out}/lib -L${pkgs.openssl.out}/lib";
            CONFIGURE_OPTS="-with-openssl=${pkgs.openssl.dev}";
            PYENV_VIRTUALENV_DISABLE_PROMPT="1";
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
            command -v pyenv &>/dev/null && eval "$(pyenv init - zsh)"
          '';
      };
  };
}

