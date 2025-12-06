{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
        # vscode
        # tmux
        gcc
        jq
        yq
        # direnv
        cmake
        # git
        # git-lfs
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
        # delve
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
        # atuin
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
  programs.go = {
    enable = true;
    packages = {
      "github.com/crosleyzack/xplr" = builtins.fetchTarball {
        url = "https://github.com/crosleyzack/xplr/archive/refs/tags/v0.2.2.tar.gz";
        sha256 = "sha256:1vs14qk0hbmhb8p89c84cmb2hamba8y42jf40dwv25pf37g342vv";
      };
    };
  };
}
