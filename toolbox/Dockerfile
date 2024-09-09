# For use with toolbox
# toolbox create --image Dockerfile devs

FROM registry.fedoraproject.org/fedora-toolbox:40

# Install
COPY packages /
RUN yum upgrade && \
    xargs yum -y install < packages
RUN rm /packages

RUN curl -fsSL https://raw.githubusercontent.com/tilt-dev/tilt/master/scripts/install.sh | bash
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
RUN go install sigs.k8s.io/kind@latest
RUN go install github.com/go-task/task/v3/cmd/task@latest
RUN go install github.com/wagoodman/dive@latest

ENV TESTCONTAINERS_RYUK_DISABLED=true

RUN cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
EOF
RUN yum install -y kubectl

RUN ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/podman && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/docker-compose && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/flatpak && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/host-spawn /usr/local/bin/distrobox
