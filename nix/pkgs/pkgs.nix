{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # general utils
      jq
      yq
      htop
      tldr
      glow
      cmake
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
