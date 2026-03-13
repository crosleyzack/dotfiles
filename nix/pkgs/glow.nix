{ pkgs, ... }:

{
  home.packages = with pkgs; [
    glow
  ];
  # config file
  home.file.glow = {
    enable = true;
    target = ".config/glow/glow.yml";
    text = ''
style: "auto"
mouse: true
pager: true
width: 80
all: false
showLineNumbers: true
preserveNewLines: false
    '';
  };
}