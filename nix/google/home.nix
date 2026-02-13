{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/gh.nix
    ../pkgs/git.nix
    ../pkgs/go.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/starship.nix
    ../pkgs/vim.nix
    ../pkgs/work.nix
    ../pkgs/xplr.nix
    ../pkgs/zsh.nix
  ];

  home = {
    username = "zackary_crosley_chainguard_dev"
    homeDirectory = "/home/zackary_crosley_chainguard_dev";
    stateVersion = "25.11";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      NIX_SYSTEM_ID = "google";
      EDITOR = "vim";
    };
    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
    ];
    shell.enableShellIntegration = true;
    shellAliases = {
      ls = "ls --color=auto";
    };
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
