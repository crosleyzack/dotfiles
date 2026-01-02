{ config, pkgs, ... }:

{
  imports = [
    ./home/pkgs.nix
    ./home/go.nix
    ./home/cli.nix
    ./home/git.nix
    ./home/tmux.nix
    ./home/code.nix
    ./home/work.nix
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
