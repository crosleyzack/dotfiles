{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/cg.nix
    ../pkgs/cli.nix
    ../pkgs/cloud.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/gh.nix
    ../pkgs/git.nix
    ../pkgs/glow.nix
    ../pkgs/go.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/ssh.nix
    ../pkgs/starship.nix
    ../pkgs/vim.nix
    ../pkgs/xplr.nix
    ../pkgs/zsh.nix
  ];

  home = {
    username = "zackary_crosley_chainguard_dev";
    homeDirectory = "/home/zackary_crosley_chainguard_dev";
    stateVersion = "26.05";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      NIX_SYSTEM_ID = "google";
      EDITOR = "vim";
      DO_NOT_TRACK = "1";
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

  my.git.identity = {
    name = "Zackary Crosley";
    email = "zackary.crosley@chainguard.dev";
  };

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = "auto";
    cores = 0;
  };

  programs.home-manager.enable = true;
}
