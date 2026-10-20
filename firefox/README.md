# <img height="30" width="30" src="https://cdn.simpleicons.org/firefox/white" style="vertical-align:middle"/> Firefox

Configuration for firefox browser

### install.sh

An apt installer that replaces the snap Firefox on Ubuntu.
Ubuntu's own `firefox` apt package is a shim that installs the snap.
The script installs native Firefox from Mozilla's apt repository instead.
It removes the Firefox snap and the Ubuntu shim package.
Run `install.sh uninstall` to remove Firefox and the Mozilla repository.
Uninstall does not bring the snap back.

### codecs.sh

Sets up video codecs for DRM content