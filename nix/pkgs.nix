# install with `nix-env -i -f pkgs.nix`
# TODO use zsh plugins zsh-autosuggestions spaceship-prompt zsh-vi-mode zsh-syntax-highlighting
with import <nixpkgs>{}; [
	vscode vim zsh tmux curl jq yq libgcc gdb direnv cmake git git-lfs diffutils whois proxychains nmap helm kubectl golangci-lint gopls delve go-task dive go protobuf grpcurl protoc-gen-go protoc-gen-go-grpc ctlptl buf man-db kind gzip htop coreutils moreutils atuin tldr
]
