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
  # For ephemeral VMs, runs bind store to mount /nix to ~/nix on luanch.
  home.file.vm_startup = {
    target = "${config.home.homeDirectory}/.config/cgw/startup.sh";
    executable = true;
    text = ''
      #!/bin/sh
      set -eu

      HOME=/home/zackary_crosley_chainguard_dev
      BACKING=$HOME/nix
      TIMEOUT=120

      elapsed=0
      while [ ! -d "$BACKING" ]; do
          if [ "$elapsed" -ge "$TIMEOUT" ]; then
              echo "startup-script: no $BACKING after $TIMEOUT seconds, leaving /nix alone" >&2
              exit 1
          fi
          elapsed=$((elapsed + 2))
          sleep 2
      done

      exec "$HOME/dev/dotfiles/nix/utils/bind-store.sh" "$BACKING"
    '';
  };
}
