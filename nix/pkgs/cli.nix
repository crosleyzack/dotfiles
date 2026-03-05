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
      nix-info
      nmap
      gping
      httpie
      posting
    ];
  };
}
