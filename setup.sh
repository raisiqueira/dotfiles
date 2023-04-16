echo "Welcome! Let's start setting up the system. It could take more than 10 minutes, be patient"

echo "Let's start with the Git setup. Set the git username: "
read git_config_username
git config --global user.name "$git_config_username"

echo "Set the git email: "
read git_config_email
git config --global user.email "$git_config_email"

echo "Update the system"
cd ~ && sudo apt update && sudo apt upgrade -y

echo "Install the basic packages"

sudo apt install -y \
    build-essential \
    curl \
    software-properties-common \
    unzip \
    wget \
    zip

echo "Install the zsh and oh-my-zsh"

sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chs -s $(which zsh)

echo "Install Spaceship ZSH theme"
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
source ~/.zshrc

# ZSH Plugins

( cd $ZSH_CUSTOM/plugins && git clone https://github.com/chrissicool/zsh-256color )
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fig
echo "Install Fig"
bash <(curl -fSsL https://fig.io/headless.sh) && exec $SHELL

echo "Install NVM"
sh -c "$(curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash)"
export NVM_DIR="$HOME/.nvm" && (
git clone https://github.com/creationix/nvm.git "$NVM_DIR"
cd "$NVM_DIR"
git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

source ~/.zshrc
clear

echo 'Installing NodeJS LTS'
nvm --version
nvm install --lts
nvm current

echo 'Bumping the max file watchers'
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

echo 'All setup, enjoy!'