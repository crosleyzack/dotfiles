{ pkgs, lib, ... }:

let
  xplr = pkgs.buildGoModule rec {
    pname = "xplr"; # Name of your application
    version = "0.3.7";   # Version of the application

    src = pkgs.fetchFromGitHub {
      owner = "crosleyzack";
      repo = "xplr";
      rev = "v${version}"; # The specific Git tag or commit hash
      sha256 = "sha256-PriHQmXDCb0oScig9UctbHkwk8heFBdU3evV0vLw7iU=";
    };

    vendorHash = "sha256-vQNkSt0g60lrqTInFYoLjXx1QUkKiieG60PBvZ6YNNo=";

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
