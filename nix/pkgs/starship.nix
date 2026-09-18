{ pkgs, ... }:

{
  programs = {
      starship = {
          enable = true;
          enableZshIntegration = true;
          settings = {
              format = "$all";
              # 30ms default trips on cold inode metadata, silently dropping
              # language modules because the file scan is left incomplete.
              scan_timeout = 100;
              battery.disabled = true;
          };
      };
  };
}

