#!/bin/bash



cat "${BASH_SOURCE%/*}/vscode-extensions.list" | xargs -L 1 code --install-extension
