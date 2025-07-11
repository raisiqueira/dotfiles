#!/bin/bash

set -e  # Exit on any error

echo "🚀 Setting up system-level packages and tools..."

echo "📦 Updating system packages"
sudo apt update && sudo apt upgrade -y

echo "🍺 Installing Homebrew"
# Check if Homebrew is already installed
if ! command -v brew &> /dev/null; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for all users
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' | sudo tee /etc/profile.d/homebrew.sh
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "✅ Homebrew already installed"
fi

echo "📦 Installing system packages via apt"
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
  zoxide \
  git

echo "🍺 Installing development tools via Homebrew"
# Install packages if they're not already installed
packages=(bat eza fd lazygit tree-sitter neovim ripgrep)
for package in "${packages[@]}"; do
    if ! brew list "$package" &> /dev/null; then
        echo "Installing $package..."
        brew install "$package"
    else
        echo "✅ $package already installed"
    fi
done

echo "⚡ Configuring system settings"
# Bump the max file watchers
if ! grep -q "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    echo "✅ File watcher limit configured"
else
    echo "✅ File watcher limit already configured"
fi

# Make zsh available to all users
if ! grep -q "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
    echo "✅ zsh added to available shells"
fi

echo ""
echo "🎉 System setup complete!"
echo "✨ Ready for user personalization..."