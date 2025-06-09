# For use with toolbox
# toolbox create --image Dockerfile devs

FROM registry.fedoraproject.org/fedora-toolbox:41

# Install packages in file
RUN yum -y install curl golang protobuf protobuf-devel protobuf-lite gcc gcc-c++ gdb kernel-devel direnv vim zsh tmux jq yq coreutils cmake gzip gettext git git-lfs ca-certificates diffutils unar telnet whois tor proxychains-ng net-tools golang-github-cloudflare-cfssl netcat host-spawn man-pages man-db man stow pgcli nmap telnet redis sqlite-devel ncurses-devel openssl-devel net-tools helm kubectl zlib-devel bzip2-devel readline-devel xsel

# Install go packages
ENV GOPATH=/usr/local/go
ENV PATH="$PATH:/usr/local/go/bin"
RUN go install github.com/go-task/task/v3/cmd/task@v3.43
RUN go install github.com/wagoodman/dive@v0.12
RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@v1.9
RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
RUN go install golang.org/x/tools/gopls@v0.18.1
RUN go install github.com/cloudspannerecosystem/spanner-cli@v0.11
RUN go install github.com/tilt-dev/ctlptl/cmd/ctlptl@v0.8.39
RUN go install github.com/bufbuild/buf/cmd/buf@v1.54
RUN go install sigs.k8s.io/kind@latest
RUN go install github.com/1player/host-spawn@latest
RUN go install github.com/crosleyzack/xplr@latest
# RUN go install github.com/charmbracelet/glow@v1.5

# turn off ryuk for test containers
ENV TESTCONTAINERS_RYUK_DISABLED=true
ENV OUTSIDE_DOCKER_HOST="172.17.0.1"

# setup atuin for tracking history
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

RUN ln -fs $(which host-spawn) /usr/sbin/podman
RUN ln -fs $(which host-spawn) /usr/sbin/flatpak
RUN ln -fs $(which host-spawn) /usr/sbin/rpm-ostree
RUN ln -fs $(which host-spawn) /usr/sbin/gsettings
RUN ln -fs $(which host-spawn) /usr/local/bin/xrandr
RUN ln -fs $(which host-spawn) /usr/local/bin/wmctrl
RUN ln -fs $(which host-spawn) /usr/local/bin/pgrep
RUN ln -fs $(which host-spawn) /usr/local/bin/dconf

# proxychains
# RUN rm -rf /usr/local/sbin/proxychains
# RUN git clone https://github.com/haad/proxychains.git $HOME/.proxychains
# RUN $HOME/.proxychains/configure && make -C $HOME/.proxychains/configure && make -C $HOME/.proxychains/configure install

# oh-my-zsh
RUN bash -c "$(curl -fsSL https://install.ohmyz.sh/)"

# setup pyenv
RUN curl -fsSL https://pyenv.run | bash
RUN curl -sSL https://install.python-poetry.org | python3 -
