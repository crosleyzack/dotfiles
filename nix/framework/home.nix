{ config, pkgs, ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/code.nix
    ../pkgs/cg.nix
    ../pkgs/cli.nix
    ../pkgs/claude.nix
    ../pkgs/cloud.nix
    ../pkgs/codeowners.nix
    ../pkgs/containers.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/docker.nix
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
    username = "zackary-crosley";
    homeDirectory = "/home/zackary-crosley";
    stateVersion = "26.05";
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

  # Expose Nix profile to GUI apps (VS Code, Claude) which inherit the systemd
  # user session environment, not the shell profile. Without this, tools like
  # gopls and gofmt are invisible to anything not launched from a terminal.
  xdg.configFile."environment.d/nix-paths.conf".text = ''
    PATH=$HOME/.nix-profile/bin:$HOME/go/bin:$HOME/.local/bin:$PATH
  '';

  # set default scaling and font size, system dependent
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.0;
      font-name = "Open Sans 12";
      document-font-name = "Open Sans 12";
      monospace-font-name = "Monaspace Argon 13";
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
    experimental-features = [ "nix-command" "flakes" "cgroups" ];
    max-jobs = "auto";
    cores = 0;
    use-cgroups = true;
  };

  programs.home-manager.enable = true;
}
