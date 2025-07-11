#!/bin/bash

echo "Welcome! Let's start setting up the system. It could take more than 10 minutes, be patient"

echo "Let's start with the Git setup. Set the git username: "
read git_config_username
git config --global user.name "$git_config_username"

echo "Set the git email: "
read git_config_email
git config --global user.email "$git_config_email"

echo "Update the system"
cd ~ && sudo apt update && sudo apt upgrade -y

echo "Install Homebrew"

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "Install the basic packages"

sudo apt install -y \
  build-essential \
  curl \
  software-properties-common \
  unzip \
  wget \
  zip \
  stow \
  zsh \
  tmux \
  fzf \
  zoxide

echo "Installing brew packages"

brew "bat"
brew "eza"
brew "fd"
brew "lazygit"
brew "tree-sitter"
brew "neovim"
brew "ripgrep"

echo "Set zsh as the default shell"
chs -s $(which zsh)

echo "Setup gnu-stow"

stow --adopt .

source ~/.zshrc

echo "Bumping the max file watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo "All setup, enjoy!"
