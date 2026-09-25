# Utils

Useful tools for managing dotfiles

### devices.sh

Changes device settings, currently just prevents touchpad from "saving power". (TODO make sure this still works)

### update.sh

Updates system including `apt`, `nix`, `python`, and more.

### rootless_docker.sh

Switches Docker to rootless mode, so the daemon runs as the current user instead of root.
Debian and Ubuntu only.
Exits early if podman is installed, because podman is already rootless.
Uncomment `DOCKER_HOST` in [nix/pkgs/docker.nix](../nix/pkgs/docker.nix) afterwards.
