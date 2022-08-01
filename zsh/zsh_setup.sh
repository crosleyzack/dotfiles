# Install zsh, if it isn't already.
sudo apt install zsh
# Make ZSH default shell.
chsh -s $(which zsh)
# Create zsh config directory, if it isn't already
mkdir ~/.config/zsh
cd ~/.config/zsh
# Install zplugin
sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zplugin/master/doc/install.sh)"
