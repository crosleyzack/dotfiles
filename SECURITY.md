### Security Policies

#### Machine Setup

When setting up a new machine, you must:

0. Pick a machine with [TPM](https://en.wikipedia.org/wiki/Trusted_Platform_Module) hardware
1. Use distribution with [SELinux or AppArmor](https://en.wikipedia.org/wiki/Security-Enhanced_Linux#Adoption)
2. Setup whole drive encryption on Linux install using LUKS (prompted during install)
3. Run [utils/security.sh](utils/security.sh) to setup good security defaults
4. Generate [new SSH key for Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) using `ssh-keygen -t ed25519 -C "mail@crosleyzack.com"`

#### Machine Maintenance

To keep the machine secure:

1. Regularly update the system with [utils/update.sh](utils/update.sh)
2. Use strong passwords with passwork manager
3. Enable 2FA on all accounts
4. Never commit API keys, tokens, or passwords and encrypt any stored locally

#### Vulnerability Reporting

I strongly recommend that expertise on vulnerability identification be spent on critical open source projects, but if for some reason it is spent on my dotfiles I suppose you can reach out to me about it as the repository owner.
