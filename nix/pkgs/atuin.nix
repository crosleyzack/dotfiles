{ pkgs, ... }:

{
  programs = {
      atuin = {
          enable = true;
          enableZshIntegration = true;
          settings = {
              style = "compact";
              search_mode = "fuzzy";
          };
      };
  };
}

