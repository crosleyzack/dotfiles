{ ... }:

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
    ../pkgs/mcp.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/proxychains.nix
    ../pkgs/rust.nix
    ../pkgs/ssh.nix
    ../pkgs/starship.nix
    ../pkgs/tmux.nix
    ../pkgs/vim.nix
    ../pkgs/wndr.nix
    ../pkgs/zed.nix
    ../pkgs/zsh.nix
  ];

  home.sessionVariables = {
    CG_WORK_UX = "2";
    # Rootless docker listens in the runtime dir, not on /var/run/docker.sock.
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/docker.sock";
  };

  # Expose Nix profile to GUI apps (VS Code, Claude) which inherit the systemd
  # user session environment, not the shell profile. Without this, tools like
  # gopls and gofmt are invisible to anything not launched from a terminal.
  xdg.configFile."environment.d/nix-paths.conf".text = ''
    PATH=$HOME/.nix-profile/bin:$HOME/go/bin:$HOME/.local/bin:$PATH
  '';

  # Same reason as above. The VS Code Dev Containers extension is not launched
  # from a shell, so it otherwise looks for the rootful socket, which
  # utils/rootless_docker.sh disables.
  xdg.configFile."environment.d/docker.conf".text = ''
    DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
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

  my.git.identity = {
    name = "Zackary Crosley";
    email = "zackary.crosley@chainguard.dev";
  };

  # Primary machine: keep the prompts.
  my.claude.profile = "workstation";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "cgroups" ];
    use-cgroups = true;
  };
}
