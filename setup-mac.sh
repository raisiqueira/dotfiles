echo "Welcome! Let's start setting up the system. It could take more than 10 minutes, be patient"

echo "Let's start with the Git setup. Set the git username: "
read git_config_username
git config --global user.name "$git_config_username"

echo "Set the git email: "
read git_config_email
git config --global user.email "$git_config_email"

echo "Install Brew packages"
brew bundle install

# Symlink the dotfiles to the home directory using gnu-stow
stow . --adopt

# Update the zshrc file
source ~/.zshrc

echo 'All setup, enjoy!'
