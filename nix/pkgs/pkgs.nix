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
      wmctrl
      nix-info
      codeowners
      xorg.xrandr
      yubikey-manager
      nerd-fonts.monaspace
      # networking
      nmap
      gping
      httpie
      posting
      cloudflared
      # github
      cosign
      gitsign
      pre-commit
      github-runner
      # languages
      uv
      # programs
      bazecor
    ];
  };
}
