{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      jq
      htop
      tldr
      cmake
      yq-go
      ranger
      man-db
      slides
      ripgrep
      nix-info
      # mermaid-cli
      # network
      nmap
      gping
      httpie
      posting
    ];
  };
}
