{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # remove this because it loads nodejs which is huge
    # github-runner
  ];
  programs = {
      gh = {
          enable = true;
          extensions = [ pkgs.gh-stack ];
          settings = {
              editor = "vim";
              git_protocol = "ssh";
              color_labels = "enabled";
              spinner = "enabled";
          };
      };
  };

  # docker-credential-gh: a Docker credential helper that returns a *live* ghcr.io
  # token from the gh CLI, so it never goes stale like a stored PAT. Exposed in
  # ~/.local/bin under the short name ~/.docker/config.json's credHelpers map
  # references; activate it with  "ghcr.io": "gh"  in config.json.
  #
  # Alternative to the docker-credential-secretservice approach noted in
  # cloud.nix -- pick ONE for ghcr.io. Unlike secretservice (a static token in
  # the keyring), this mints a fresh token per request: nothing to seed, nothing
  # to rotate. Only the `get` verb does work; store/erase/list are no-ops.
  home.file.ghcr_cred_helper = {
    enable = true;
    executable = true;
    target = ".local/bin/docker-credential-gh";
    text = ''
      #!${pkgs.bash}/bin/bash
      set -euo pipefail

      if [[ "''${1:-}" != "get" ]]; then
        cat >/dev/null 2>&1 || true
        exit 0
      fi

      read -r host || true
      if [[ "$host" != "ghcr.io" ]]; then
        echo "credentials not found in native keychain" >&2
        exit 1
      fi

      token="$(${pkgs.gh}/bin/gh auth token 2>/dev/null || true)"
      if [[ -z "$token" ]]; then
        echo "credentials not found in native keychain" >&2
        exit 1
      fi

      printf '{"ServerURL":"ghcr.io","Username":"token","Secret":"%s"}\n' "$token"
    '';
  };
}
