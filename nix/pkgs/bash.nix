{ pkgs, ... }:

{
  home.shell.enableBashIntegration = true;

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
  };
}

