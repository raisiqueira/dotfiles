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

# Handle existing dotfiles conflicts
echo "Checking for existing dotfile conflicts..."

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List of common files that might conflict
COMMON_CONFLICTS=(.profile .bashrc .bash_profile .bash_logout .vimrc .gitconfig)

# Check for conflicts and backup if needed
conflicts_found=false
for file in "${COMMON_CONFLICTS[@]}"; do
  if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
    if [ "$conflicts_found" = false ]; then
      echo "Found existing configuration files. Creating backup in $BACKUP_DIR"
      mkdir -p "$BACKUP_DIR"
      conflicts_found=true
    fi
    echo "Backing up existing $file"
    cp "$HOME/$file" "$BACKUP_DIR/"
    rm "$HOME/$file"
  fi
done

# Try to stow dotfiles
if [ -d ".git" ]; then
  # We're in a git repository (dotfiles directory)
  echo "Stowing dotfiles..."
  if stow . 2>/dev/null; then
    echo "Dotfiles stowed successfully"
  else
    echo "Stow failed. Trying with --adopt flag..."
    if stow --adopt . 2>/dev/null; then
      echo "Dotfiles adopted and stowed successfully"
      echo "Note: Some existing configs were adopted into your dotfiles repo"
    else
      echo "Warning: Could not stow dotfiles automatically."
      echo "You may need to resolve conflicts manually."
      echo "Try running: stow --adopt . or stow --override ."
    fi
  fi
else
  echo "Warning: Not in a dotfiles directory. Skipping stow setup."
  echo "Make sure to run this script from your dotfiles repository root."
fi

if [ "$conflicts_found" = true ]; then
  echo "Backup of original files created in: $BACKUP_DIR"
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
