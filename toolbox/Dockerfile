# For use with toolbox
# toolbox create --image Dockerfile devs

FROM registry.fedoraproject.org/fedora-toolbox:41

# Install packages in file
RUN yum -y install golang protobuf protobuf-devel protobuf-lite gcc gcc-c++ gdb kernel-devel direnv vim zsh tmux jq yq coreutils cmake gzip gettext git git-lfs ca-certificates diffutils unar telnet whois tor proxychains-ng net-tools golang-github-cloudflare-cfssl netcat host-spawn man-pages man-db man stow pgcli nmap telnet redis sqlite-devel ncurses-devel openssl-devel net-tools
# WARN: even basic tex adds 400 packages, not worth having

# setup atuin for tracking history
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Install go packages
RUN go install github.com/go-task/task/v3/cmd/task@latest
RUN go install github.com/wagoodman/dive@latest
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.20
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2
RUN go install golang.org/x/tools/gopls@v0.16.2
RUN go install github.com/cloudspannerecosystem/spanner-cli@latest
RUN go install github.com/tilt-dev/ctlptl/cmd/ctlptl@latest
# TODO do these work in container?
# RUN go install sigs.k8s.io/kind@latest

# turn off ryuk for test containers
ENV TESTCONTAINERS_RYUK_DISABLED=true

ENV OUTSIDE_DOCKER_HOST="172.17.0.1"

# WARN: Kubectl causes toolbox to hang for some reason
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/podman
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/docker
# RUN ln -fs /usr/bin/host-spawn /usr/local/bin/kubectl
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/helm
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/docker-compose
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/cloud-sql-proxy
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/flatpak
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/rpm-ostree
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/distrobox
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/code
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/tilt
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/gcloud
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/xrandr
RUN ln -fs /usr/bin/host-spawn /usr/local/bin/wmctrl

# install kubectx - these are just bash scripts so they can be installed in container
# RUN git clone https://github.com/ahmetb/kubectx /usr/local/kubectx
# RUN ln -s /usr/local/kubectx/kubectx /usr/local/bin/kubectx
# RUN ln -s /usr/local/kubectx/kubens /usr/local/bin/kubens
