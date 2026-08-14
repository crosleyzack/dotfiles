{ pkgs, lib, ... }:

let
  xplr = pkgs.buildGoModule rec {
    pname = "xplr"; # Name of your application
    version = "0.3.1";   # Version of the application

    src = pkgs.fetchFromGitHub {
      owner = "crosleyzack";
      repo = "xplr";
      rev = "v${version}"; # The specific Git tag or commit hash
      sha256 = "sha256-QsA26pU22NxHSdbINauZAcO9IlNqrV+W4NbaCSWWz1Q=";
    };

    vendorHash = "sha256-ECWzWOktoOahA1d09ofQmI7zdnVZcvRaTv2kGSKYwdc=";

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
