{ pkgs, ... }:

{
  programs = {
      gh = {
          enable = true;
          settings = {
              editor = "vim";
              git_protocol = "ssh";
              color_labels = "enabled";
              spinner = "enabled";
          };
      };
  };
}
