# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/rai/.zsh/completions:"* ]]; then export FPATH="/Users/rai/.zsh/completions:$FPATH"; fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Brew utils
if [ -d "/opt/homebrew/bin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Path overrides goes here
## NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## PNPM
export PNPM_HOME="/Users/rai/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

## bun
[ -s "/Users/rai/.bun/_bun" ] && source "/Users/rai/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## Rust
export PATH="$HOME/.cargo/bin:$PATH"

#Python
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# ---- ZINIT ----
# ZInit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# auto-download zinit
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Tmux TPM
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Directory ~/.tmux/plugins/tpm does not exist. Cloning repository..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Powerlevel10k theme
zinit ice depth=1; zinit light romkatv/powerlevel10k

# ZSH Plugins
zinit ice depth=1; zinit light zsh-users/zsh-syntax-highlighting
zinit ice depth=1; zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light zsh-users/zsh-autosuggestions
zinit ice depth=1; zinit light Aloxaf/fzf-tab
zinit ice depth=1; zinit light MichaelAquilina/zsh-you-should-use
zinit ice depth=1; zinit light chrissicool/zsh-256color

# Zinit snippets
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Key bindings
bindkey '^f' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History manager
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completions styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle 'completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Functions

upgrade_ai_packages() {
  npm install -g opencode-ai
  npm install -g @anthropic-ai/claude-code@latest
  npm install -g @google/gemini-cli
}

# Aliases
alias ls='ls --color'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias vim="nvim"
alias vi="nvim"
alias top="btop"
alias cat="bat"
alias l="eza -l --icons --git -a"
alias ls="eza --icons --group-directories-first --git"
alias lg="lazygit"
alias upgrade_ai_packages='upgrade_ai_packages'

# Shell Integration
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# homebrew configs
export HOMEBREW_BREWFILE_VSCODE=0

# . "/Users/rai/.deno/env"
# . "$HOME/.local/bin/env"
