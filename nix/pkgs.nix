# install with `nix-env -i -f pkgs.nix`
# NOTE: install zsh via your system package manager currently
# TODO use zsh plugins zsh-autosuggestions spaceship-prompt zsh-vi-mode zsh-syntax-highlighting
with import <nixpkgs>{}; [
	vscode tmux jq yq direnv cmake git git-lfs gitsign github-runner tor proxychains nmap helm kubectl kubectx leiningen go golint gopls delve go-task dive protobuf grpcurl grpc-gateway protoc-gen-go protoc-gen-go-grpc ctlptl buf man-db kind htop ctop atuin tldr nix-info wmctrl xorg.xrandr yubikey-manager crane redis google-cloud-sql-proxy google-cloud-sdk postgresql sqlite httpie posting ranger cloudflared gping uv apko codeowners cosign docker-credential-gcr step-cli terraform terraform-docs slides glow
]
