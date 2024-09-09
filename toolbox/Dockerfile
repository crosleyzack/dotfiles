# For use with toolbox
# toolbox create --image Dockerfile devs

FROM registry.fedoraproject.org/fedora-toolbox:40

# Install packages in file
COPY packages /
RUN yum upgrade && \
    xargs yum -y install < packages
RUN rm /packages

# setup additional tools
RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
RUN go install sigs.k8s.io/kind@latest
RUN go install github.com/go-task/task/v3/cmd/task@latest
RUN go install github.com/wagoodman/dive@latest
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.20
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

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

# turn off ryuk for test containers
ENV TESTCONTAINERS_RYUK_DISABLED=true

# Setup tmux
# RUN PLUGINS_DIR="$HOME/.config/tmux/plugins"
# RUN rm -rf $PLUGINS_DIR && mkdir -p $PLUGINS_DIR
# RUN git clone https://github.com/tmux-plugins/tpm $PLUGINS_DIR/tpm
# RUN git clone https://github.com/tmux-plugins/tmux-resurrect $PLUGINS_DIR/resurrect
# RUN git clone https://github.com/tmux-plugins/tmux-continuum $PLUGINS_DIR/continuum
# RUN git clone https://github.com/erikw/tmux-powerline.git $PLUGINS_DIR/powerline

RUN ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/podman && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/docker-compose && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/flatpak && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/distrobox
