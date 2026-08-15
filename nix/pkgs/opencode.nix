{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opencode
  ];
  home.file.opencode = {
    enable = true;
    executable = false;
    target = ".config/opencode/opencode.json";
    text = ''
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {},
  "model": "deepseek/deepseek-v4-flash-free",
  "small_model": "deepseek/deepseek-v4-flash-free"
}
    '';
  };
}
