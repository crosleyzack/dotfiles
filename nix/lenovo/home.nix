{ ... }:

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
    ../pkgs/zed.nix
    ../pkgs/zsh.nix
  ];

  # Fedora holds no multiarch directory.
  my.dev.zed.vulkanLibs = "/usr/lib64";

  # for fedora machines
  home.shellAliases = {
    docker = "podman";
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

  my.git.identity = {
    name = "crosleyzack";
    email = "mail@crosleyzack.com";
  };

  # this machine has podman, not docker
  my.dev.containers.dockerPath = "podman";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "cgroups" ];
    use-cgroups = true;
  };
}
