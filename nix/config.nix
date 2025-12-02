{
    allowUnfree = true;
    packageOverrides = pkgs: with pkgs; {
        myPackages = pkgs.buildEnv {
          name = "my-packages";
          paths = [
            vscode tmux jq yq direnv cmake git git-lfs gitsign github-runner tor proxychains nmap helm kubectl kubectx leiningen go golint gopls delve go-task dive  protobuf grpcurl grpc-gateway protoc-gen-go protoc-gen-go-grpc ctlptl buf man-db    kind htop ctop atuin tldr nix-info wmctrl xorg.xrandr yubikey-manager crane redis   google-cloud-sql-proxy google-cloud-sdk postgresql sqlite httpie posting ranger     cloudflared gping uv apko codeowners cosign docker-credential-gcr step-cli          terraform terraform-docs slides glow
          ];
        };
    };
}
