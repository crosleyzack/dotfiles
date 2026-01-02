{ config, pkgs, ... }:

{
  imports = [
    ../shared/pkgs.nix
    ../shared/go.nix
    ../shared/cli.nix
    ../shared/git.nix
    ../shared/tmux.nix
    # packages for work computer
    ../shared/work.nix
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
    shellAliases = {
      ls = "ls --color=auto";
    };
  };

  # allow non-free packages to be installed, like terraform
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
