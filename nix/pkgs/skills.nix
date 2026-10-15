{ config, pkgs, lib, ... }:

# One link for each skill plugin, straight to its source in the store.
#
# The folder loads as "<name>@skills-dir": no install step, and no write to
# the read-only settings file. It needs a plugin.json.
let
  skillPlugins = {
    mattpocock-skills = pkgs.fetchFromGitHub {
      owner = "mattpocock";
      repo = "skills";
      rev = "959a8e9f1edc3adbe2f7e3054bb6fbefa6696260"; # v1.2.3
      hash = "sha256-AbIlPEE0VWJq+NJpa56SDzhM8o7vXDBtlJHS5FCTElE=";
    };
    cc-skills-golang = pkgs.fetchFromGitHub {
      owner = "samber";
      repo = "cc-skills-golang";
      rev = "053894c088317d7ba2038cffcbf5fd57b5494fa6"; # v2.0.0
      hash = "sha256-d7HZ+oxuEgLIM6tXFLxT1JrXBbNsvIVMOprbqdlrOWs=";
    };
  };
in
{
  home.file = lib.mapAttrs'
    (name: src: lib.nameValuePair "claude_skill_${name}" {
      enable = true;
      target = "${config.home.homeDirectory}/.claude/skills/${name}";
      source = src;
    })
    skillPlugins;
}
