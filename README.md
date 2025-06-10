# dotfiles

My dotfiles.

## Requirements

- Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- GNU Stow `brew install stow`

## Setup

Setup by using the `setup-mac.sh` script or the `setup.sh` (Ubuntu) script.

## Manual Setup

### Install the Homebrew packages

```bash
brew bundle install
```

### Setup the dotfiles

Inside the `dotfiles` folder, run the following command:

```bash
stow --adopt .
```

## Updating the `Brewfile`

```bash
brew bundle dump --force --no-vscode
```
