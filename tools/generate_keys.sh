#!/bin/bash
sudo apt-get install -y \
    gnupg
    scdaemon

# Sources:
#  https://support.yubico.com/hc/en-us/articles/360013790259-Using-Your-YubiKey-with-OpenPGP
#  https://unix.stackexchange.com/questions/253462/why-do-gnupg-2-and-gpg-connect-agent-fail-with-err-67108983-no-smartcard-daemon

gpg --expert --full-gen-key
