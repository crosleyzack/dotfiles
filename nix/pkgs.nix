# install with `nix-env -i -A -f pkgs.nix`
# TODO use zsh plugins zsh-autosuggestions spaceship-prompt zsh-vi-mode zsh-syntax-highlighting
# TODO add wmctrl and xrandr
with import <nixpkgs>{}; [
	vscode tmux jq yq libgcc direnv cmake git git-lfs tor proxychains nmap helm kubectl go golangci-lint gopls delve go-task dive go protobuf grpcurl protoc-gen-go protoc-gen-go-grpc ctlptl buf man-db kind htop atuin tldr nix-info
]
