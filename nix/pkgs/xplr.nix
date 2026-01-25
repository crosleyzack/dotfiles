{ pkgs, lib, ... }:

let
  xplr = pkgs.buildGoModule rec {
    pname = "xplr"; # Name of your application
    version = "0.2.5";   # Version of the application

    src = pkgs.fetchFromGitHub {
      owner = "crosleyzack";
      repo = "xplr";
      rev = "v0.2.5"; # The specific Git tag or commit hash
      sha256 = "sha256-ex0ya6drPoC0GhCtlBm2Wz0Qo3RPxBQwSkHU3XUozag=";
    };

    vendorHash = "sha256-yVeuz/S1VPEXDK/AOIGpS/gefdGnyWnMG/IJjB3ctDM=";

    meta = with lib; {
      description = "Explore tree-based file formats as an interactive TUI tree";
      homepage = "https://github.com/crosleyzack/xplr";
      license = licenses.mit; # Choose the correct license
      platforms = platforms.all;
    };
  };

in
{
  # Ensure the package is added to your user environment
  home.packages = [
    xplr
  ];
}
