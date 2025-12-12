{ config, pkgs, ... }:

{
  imports = [
    ./home/pkgs.nix
    ./home/go.nix
    ./home/cli.nix
    ./home/git.nix
    ./home/tmux.nix
    # packages for work computer
    ./home/work.nix
    # vscode doesn't work on this computer
    # ./home/code.nix
  ];

  home = {
    username = "zackary-crosley";
    homeDirectory = "/home/zackary-crosley";
    stateVersion = "25.11";
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      EDITOR = "vim";
    };
    sessionPath = [
      "$HOME/go/bin"
      "$HOME/.local/bin"
    ];
    shell.enableShellIntegration = true;
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
