# Creates a container for development

Uses [Toolbx](https://containertoolbx.org) to setup a development container

## Setting up
```
podman build -t devs-image -f Dockerfile .
toolbox create --image devs-image devs
toolbox enter devs
```

## Removing

```
podman stop devs
toolbox rm devs
toolbox rmi devs-image
```

## TODO

- Get working with desired libraries
- Resume tmux in container on startup
