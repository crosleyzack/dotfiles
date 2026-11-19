{ ... }:

{
  imports = [
    ../pkgs/atuin.nix
    ../pkgs/bash.nix
    ../pkgs/cg.nix
    ../pkgs/claude.nix
    ../pkgs/skills.nix
    ../pkgs/cli.nix
    ../pkgs/cloud.nix
    ../pkgs/dircolors.nix
    ../pkgs/direnv.nix
    ../pkgs/gh.nix
    ../pkgs/git.nix
    ../pkgs/glow.nix
    ../pkgs/go.nix
    ../pkgs/mcp.nix
    ../pkgs/pkgs.nix
    ../pkgs/protobuf.nix
    ../pkgs/ssh.nix
    ../pkgs/starship.nix
    ../pkgs/vim.nix
    ../pkgs/wndr.nix
    ../pkgs/yubikey.nix
    ../pkgs/zsh.nix
  ];

  my.git.identity = {
    name = "Zackary Crosley";
    email = "zackary.crosley@chainguard.dev";
  };

  # Disposable VM: a new root disk arrives at every start, thus only the
  # checkout is worth protecting. Claude runs local tools without a prompt, and
  # a remote write fails, apart from the few that claude.nix names.
  my.claude.profile = "sandbox";

  # This VM runs no build in a cgroup, unlike the other machines.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
