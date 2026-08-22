{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/code.nix
    ../pkgs/cli.nix
    # ../pkgs/cg.nix
    # ../pkgs/cloud.nix
    ../pkgs/containers.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/fonts.nix
    ../pkgs/gh.nix
    ../pkgs/git.nix
    ../pkgs/glow.nix
    ../pkgs/gnome.nix
    ../pkgs/go.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/proxychains.nix
    ../pkgs/rust.nix
    ../pkgs/ssh.nix
    ../pkgs/starship.nix
    ../pkgs/tmux.nix
    ../pkgs/vim.nix
    ../pkgs/wndr.nix
    ../pkgs/zsh.nix
  ];

  home = {
    username = "crosleyzack";
    homeDirectory = "/home/crosleyzack";
    stateVersion = "26.05";
    # for fedora machines
    shellAliases = {
      docker = "podman";
    };
    sessionVariables = {
      NIX_SYSTEM_ID = "lenovo";
      MOZ_ENABLE_WAYLAND = 1;
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
      # text-scaling-factor = 1.0;
      # font-name = "Open Sans 11";
      # document-font-name = "Open Sans 11";
      # monospace-font-name = "Monaspice 13";
    };
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  my.git.identity = {
    name = "crosleyzack";
    email = "mail@crosleyzack.com";
  };

  # this machine has podman, not docker
  my.dev.containers.dockerPath = "podman";

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "cgroups" ];
    max-jobs = "auto";
    cores = 0;
    use-cgroups = true;
  };

  programs.home-manager.enable = true;
}
