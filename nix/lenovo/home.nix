{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/code.nix
    ../pkgs/cli.nix
    # ../pkgs/cloud.nix
    ../pkgs/containers.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/flatpak.nix
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
    # ../pkgs/work.nix
    ../pkgs/xplr.nix
    ../pkgs/zsh.nix
  ];

  home = {
    username = "crosleyzack";
    homeDirectory = "/home/crosleyzack";
    stateVersion = "25.11";
    # for fedora machines
    shellAliases = {
      docker = "podman";
    };
    sessionVariables = {
      NIX_SYSTEM_ID = "lenovo";
      MOZ_ENABLE_WAYLAND = 1;
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
