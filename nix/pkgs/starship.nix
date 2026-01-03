{ pkgs, ... }:

{
  programs = {
      starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
              format = "$all";
              battery.disabled = true;
          };
      };
  };
}

