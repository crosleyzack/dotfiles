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
        gcc
        jq
        yq
        cmake
        gitsign
        github-runner
        tor   
        proxychains
        nmap
        helm
        kubectl
        kubectx
        leiningen
        golint
        gopls
        go-task
        dive 
        protobuf
        grpcurl
        grpc-gateway
        protoc-gen-go
        protoc-gen-go-grpc
        ctlptl
        buf
        man-db   
        kind
        htop
        ctop
        tldr
        nix-info
        wmctrl
        xorg.xrandr
        yubikey-manager
        crane
        redis  
        google-cloud-sql-proxy
        google-cloud-sdk
        postgresql
        sqlite
        httpie
        posting
        ranger    
        cloudflared
        gping
        uv
        apko
        codeowners
        cosign
        docker-credential-gcr
        step-cli         
        terraform
        terraform-docs slides glow
        nerd-fonts.monaspace
        bazecor
    ];
  };
}
