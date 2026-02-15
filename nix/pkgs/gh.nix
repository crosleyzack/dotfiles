{ pkgs, ... }:

{
  home.packages = with pkgs; [
    github-runner
  ];
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
