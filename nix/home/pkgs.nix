{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
        # setup elsewhere
        # vscode
        # tmux
        # direnv
        # git
        # git-lfs
        # atuin
        jq
        yq
        htop
        tldr
        glow
        cmake
        ranger    
        man-db   
        slides
        wmctrl
        nix-info
        step-cli         
        xorg.xrandr
        yubikey-manager
        nerd-fonts.monaspace
        # networking
        tor
        nmap
        gping
        httpie
        posting
        proxychains
        # cloud
        redis  
        sqlite
        mysql84
        postgresql
        cloudflared
        google-cloud-sdk
        google-cloud-sql-proxy
        # github
        codeowners
        cosign
        gitsign
        github-runner
        # containers
        ctop
        dive 
        kind
        helm
        crane
        ctlptl
        kubectl
        kubectx
        terraform
        terraform-docs
        docker-credential-gcr
        # languages
        uv
        gcc
        golint
        gopls
        gotests
        gotools
        go-task
        golangci-lint
        # protobuf
        buf
        grpcurl
        protobuf
        grpc-gateway
        protoc-gen-go
        protoc-gen-go-grpc
        # programs
        bazecor
        # chainguard
        apko
        melange
    ];
  };
}
