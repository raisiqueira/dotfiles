#!/bin/bash

set -e # Exit on any error

echo "Welcome! Let's start setting up the system. It could take more than 10 minutes, be patient"

echo "Update the system"
cd ~ && sudo apt update && sudo apt upgrade -y

echo "Install Homebrew"

# Check if Homebrew is already installed
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH
  echo >>/home/coder/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/coder/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  echo "Homebrew already installed"
fi

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

# Install packages if they're not already installed
packages=(bat eza fd lazygit tree-sitter neovim ripgrep)
for package in "${packages[@]}"; do
  if ! brew list "$package" &>/dev/null; then
    echo "Installing $package..."
    brew install "$package"
  else
    echo "$package already installed"
  fi
done

echo "Setting up zsh as the default shell"

# Try different methods to set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  # Method 1: Try chsh with sudo
  if sudo chsh -s "$(which zsh)" "$USER" 2>/dev/null; then
    echo "Successfully changed default shell to zsh"
  else
    echo "Warning: Could not change default shell using chsh. Trying alternative method..."

    # Method 2: Add to shell profile to automatically start zsh
    if ! grep -q "exec zsh" ~/.bashrc; then
      echo "" >>~/.bashrc
      echo "# Auto-start zsh if available and not already running" >>~/.bashrc
      echo "if [ -x \"\$(command -v zsh)\" ] && [ \"\$BASH_EXECUTION_STRING\" = \"\" ] && [ \"\$0\" = \"-bash\" ]; then" >>~/.bashrc
      echo "    exec zsh" >>~/.bashrc
      echo "fi" >>~/.bashrc
      echo "Added zsh auto-start to .bashrc"
    fi
  fi
else
  echo "zsh is already the default shell"
fi

echo "Setup gnu-stow"

# Check if dotfiles are already stowed
if [ ! -f ~/.zshrc ] || [ ! -L ~/.zshrc ]; then
  stow --adopt .
  echo "Dotfiles stowed successfully"
else
  echo "Dotfiles appear to already be stowed"
fi

echo "Bumping the max file watchers"
# Check if the setting is already there
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
  echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
else
  echo "File watcher limit already configured"
fi

# Source zshrc if it exists
if [ -f ~/.zshrc ]; then
  echo "Sourcing .zshrc..."
  # Use zsh to source the file
  zsh -c "source ~/.zshrc" || echo "Note: Some zsh configurations may require a new shell session"
fi

echo ""
echo "================================================"
echo "Setup complete! 🎉"
echo "================================================"
echo ""
echo "Note: If zsh didn't become your default shell automatically,"
echo "you can start a new zsh session by running: zsh"
echo ""
echo "For the changes to take full effect, consider:"
echo "1. Logging out and back in, or"
echo "2. Starting a new terminal session"
echo ""
echo "Enjoy your new development environment!"
