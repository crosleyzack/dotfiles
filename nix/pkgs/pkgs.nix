{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # general utils
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
      yubikey-manager
      nerd-fonts.monaspace
      # networking
      nmap
      gping
      httpie
      posting
      cloudflared
      # languages
      uv
      # programs
      bazecor
    ];
  };
}
