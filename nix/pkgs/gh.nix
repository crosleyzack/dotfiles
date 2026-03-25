{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # remove this because it loads nodejs which is huge
    # github-runner
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
