{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # general utils
      yubikey-manager
      nerd-fonts.monaspace
      # languages
      uv
      # programs
      bazecor
    ];
  };
}
