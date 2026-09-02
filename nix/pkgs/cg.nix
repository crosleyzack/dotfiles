{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    step-cli
    # scanning
    syft
    grype
    trivy
    # images
    cue
    apko
    melange
  ];

  # A new VM gets a new root disk, thus it loses /nix. The tool reads this file
  # at every start, and copies the script to the new machine as boot metadata.
  # The script binds /nix to the data disk again. See ../utils/bind-store.sh.
  home.file.work_conf = {
    target = "${config.home.homeDirectory}/.config/cgw/config.toml";
    text = ''
      [pets]
      script = "${config.home.homeDirectory}/.config/cgw/startup.sh"
      ssh-config = """
        ForwardAgent yes
      """
    '';
  };
  home.file.vm_startup = {
    target = "${config.home.homeDirectory}/.config/cgw/startup.sh";
    executable = true;
    text = ''
      #!/bin/sh
      ${config.home.homeDirectory}/dev/dotfiles/nix/utils/bind-store.sh ${config.home.homeDirectory}/nix
    '';
  };
}
