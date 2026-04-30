{ pkgs, ... }:

{
  home = {
    # contains all packages that don't fit elsewhere
    packages = with pkgs; [
      # general utils
      yubikey-manager
      # languages
      uv
      # programs
      # bazecor
    ];
  };
}
