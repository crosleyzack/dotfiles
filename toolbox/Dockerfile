# For use with toolbox
# toolbox create --image Dockerfile devs

FROM registry.fedoraproject.org/fedora-toolbox:40

# Install packages in file
RUN yum -y install golang protobuf protobuf-devel protobuf-lite gcc gcc-c++ gdb kernel-devel helm direnv vim zsh tmux jq yq coreutils cmake gzip gettext git git-lfs ca-certificates diffutils unar telnet whois tor proxychains-ng net-tools golang-github-cloudflare-cfssl netcat host-spawn man-pages man-db man stow pgcli nmap telnet redis sqlite-devel texlive-scheme-basic ncurses-devel openssl-devel net-tools

# setup additional tools
# RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
RUN go install sigs.k8s.io/kind@latest
RUN go install github.com/go-task/task/v3/cmd/task@latest
RUN go install github.com/wagoodman/dive@latest
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.20
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN go install golang.org/x/tools/gopls@v0.16.2
RUN go install github.com/cloudspannerecosystem/spanner-cli@latest

# setup google cloud
# RUN tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
# [google-cloud-cli]
# name=Google Cloud CLI
# baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
# enabled=1
# gpgcheck=1
# repo_gpgcheck=0
# gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
# EOM
# RUN dnf install libxcrypt-compat.x86_64
# RUN dnf install google-cloud-cli google-cloud-cli-pubsub-emulator google-cloud-cli-spanner-emulator

# setup kubernetes
RUN cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
RUN yum install -y kubectl

# install kubectx
# git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
# ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
# ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens

# turn off ryuk for test containers
ENV TESTCONTAINERS_RYUK_DISABLED=true

# Setup tmux
# RUN PLUGINS_DIR="$HOME/.config/tmux/plugins"
# RUN rm -rf $PLUGINS_DIR && mkdir -p $PLUGINS_DIR
# RUN git clone https://github.com/tmux-plugins/tpm $PLUGINS_DIR/tpm
# RUN git clone https://github.com/tmux-plugins/tmux-resurrect $PLUGINS_DIR/resurrect
# RUN git clone https://github.com/tmux-plugins/tmux-continuum $PLUGINS_DIR/continuum
# RUN git clone https://github.com/erikw/tmux-powerline.git $PLUGINS_DIR/powerline

RUN ln -fs /usr/bin/host-spawn /usr/bin/podman
RUN ln -fs /usr/bin/host-spawn /usr/bin/docker
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/docker-compose
RUN ln -fs /usr/bin/host-spawn /usr/bin/flatpak
RUN ln -fs /usr/bin/host-spawn /usr/bin/rpm-ostree
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/distrobox
RUN ln -fs /usr/bin/host-spawn /usr/bin/code
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/tilt
RUN ln -fs /usr/bin/host-spawn /usr/bin/gcloud
RUN ln -fs /usr/bin/host-spawn /usr/bin/xrandr
RUN ln -fs /usr/bin/host-spawn /usr/bin/wmctrl
