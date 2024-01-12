# Distrobox

Containerized development environment. Use `distrobox assemble create` to build containers, `distrobox assemble rm` to remove containers, and `distrobox enter <container name>` to enter containers.

# Permissioning

Add `--privileged` to run as real root. This removes some security benefits, but is no different than installing these same libraries locally. Ex:

```
distrobox enter alpine_dev --additional-flags "--privileged"
```
