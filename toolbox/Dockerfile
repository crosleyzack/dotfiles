# For use with toolbox
# toolbox create --image Dockerfile devs

# FROM quay.io/toolbx-images/alpine-toolbox:edge
FROM registry.fedoraproject.org/fedora:39

COPY packages /
RUN dnf upgrade
  grep -v '^#' /packages | xargs dnf install
RUN rm /packages

RUN ln -fs /bin/sh /usr/bin/sh && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker-compose && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
  ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/distrobox
