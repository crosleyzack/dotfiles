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
        cloudflared
        # github
        codeowners
        cosign
        gitsign
        pre-commit
        github-runner
        # containers
        ctop
        dive 
        # languages
        uv
        # programs
        bazecor
    ];
  };
}
