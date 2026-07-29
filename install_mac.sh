#!/bin/bash

set -e

# Get the absolute path to the directory this script is in
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

copy_file() {
    local source="$1"
    local target="$2"
    if [ -e "$target" ]; then
        local timestamp
        timestamp="$(date +%Y%m%d-%H%M%S)"
        mv "$target" "$target.old.$timestamp"
    fi
    cp "$source" "$target"
}

# 1. Install Zsh Autosuggestions
echo "Checking zsh-autosuggestions..."
mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed, pulling latest..."
    git -C "$HOME/.zsh/zsh-autosuggestions" pull
fi

# 2. Copy dotfiles
echo "Copying dotfiles..."
copy_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
copy_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
copy_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
copy_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
copy_file "$DOTFILES_DIR/.psqlrc" "$HOME/.psqlrc"
copy_file "$DOTFILES_DIR/utils.zsh" "$HOME/utils.zsh"

# Git identity
echo "Configuring Git identity..."
read -p "Enter your full name for Git: " git_name
read -p "Enter your email address for Git: " git_email
git config --file "$HOME/.gitconfig" user.name "$git_name"
git config --file "$HOME/.gitconfig" user.email "$git_email"


# 4. Copy starship config
echo "Copying Starship config..."
mkdir -p "$HOME/.config"
copy_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# 5. Copy bin directory
echo "Copying bin directory..."
mkdir -p "$HOME/bin"
cp -r "$DOTFILES_DIR/bin/"* "$HOME/bin/"

# 6. Install Homebrew if not found
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon / Intel Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        (echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'; cat "$HOME/.zshrc") > "$HOME/.zshrc.new"
        mv "$HOME/.zshrc.new" "$HOME/.zshrc"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        (echo 'eval "$(/usr/local/bin/brew shellenv)"'; cat "$HOME/.zshrc") > "$HOME/.zshrc.new"
        mv "$HOME/.zshrc.new" "$HOME/.zshrc"
    fi
fi

# 7. Install Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# 8. Install Devbox
echo "Installing Devbox..."
if ! command -v devbox &> /dev/null; then
    curl -fsSL https://get.jetify.com/devbox | bash
fi

# 9. Install CLI tools globally from devbox.json
echo "Installing/Updating CLI tools from devbox.json..."
mkdir -p "$HOME/.local/share/devbox/global/default"
cp "$DOTFILES_DIR/devbox.json" "$HOME/.local/share/devbox/global/default/devbox.json"

pushd "$HOME/.local/share/devbox/global/default" > /dev/null
devbox install
popd > /dev/null

echo "Installation complete! Restart your terminal."
