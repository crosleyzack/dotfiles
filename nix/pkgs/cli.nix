{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      jq
      htop
      tldr
      glow
      cmake
      yq-go
      ranger
      man-db
      slides
      ripgrep
      nix-info
      # network
      nmap
      gping
      httpie
      posting
    ];
  };
}
