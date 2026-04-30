{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # better font for small sizes
      open-sans
      # good monospace font
      nerd-fonts.monaspace
    ];
  };
  
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Open Sans" ];
      serif = [ "Open Sans" ];
      monospace = [ "Monaspace Argon" ];
    };
  };
}


