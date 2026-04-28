{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/code.nix
    ../pkgs/cli.nix
    ../pkgs/claude.nix
    ../pkgs/cloud.nix
    ../pkgs/codeowners.nix
    ../pkgs/containers.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/gh.nix
    ../pkgs/git.nix
    ../pkgs/glow.nix
    ../pkgs/gnome.nix
    ../pkgs/go.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/proxychains.nix
    ../pkgs/ssh.nix
    ../pkgs/starship.nix
    ../pkgs/tmux.nix
    ../pkgs/vim.nix
    ../pkgs/work.nix
    ../pkgs/xplr.nix
    ../pkgs/zsh.nix
  ];

  home = {
    username = "zackary-crosley";
    homeDirectory = "/home/zackary-crosley";
    stateVersion = "25.11";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      NIX_SYSTEM_ID = "framework";
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

  # set default scaling and font size, system dependent
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.2;
      font-name = "Ubuntu 12";
      document-font-name = "Ubuntu 12";
      monospace-font-name = "Monaspice 13";
    };
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
