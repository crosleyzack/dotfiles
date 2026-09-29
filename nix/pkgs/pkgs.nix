{ pkgs, ... }:

{
  home = {
    # contains all packages that don't fit elsewhere
    packages = with pkgs; [
      # languages
      uv
      pyenv
      # programs
      # bazecor
    ];
  };
}
