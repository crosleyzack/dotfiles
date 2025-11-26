# install with `nix-env -i -f pkgs.nix`
# NOTE: install zsh via your system package manager currently
# TODO use zsh plugins zsh-autosuggestions spaceship-prompt zsh-vi-mode zsh-syntax-highlighting
with import <nixpkgs>{}; [
	vscode tmux jq yq libgcc direnv cmake git git-lfs tor proxychains nmap helm kubectl kubectx leiningen go golangci-lint gopls delve go-task dive go protobuf grpcurl protoc-gen-go protoc-gen-go-grpc ctlptl buf man-db kind htop ctop atuin tldr nix-info wmctrl xorg.xrandr yubikey-manager crane redis google-cloud-sql-proxy google-cloud-sdk postgresql sqlite httpie posting ranger cloudflared gping uv github-runner
]
