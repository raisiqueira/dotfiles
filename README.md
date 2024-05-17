# dotfiles

My dotfiles.

## Requirements

- Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- GNU Stow `brew install stow`

## Install the Homebrew packages

```bash
brew bundle install
```

## Setup the dotfiles

Inside the `dotfiles` folder, run the following command:

```bash
stow --adopt .
```

## Updating the `Brewfile`

```bash
brew bundle dump
```
