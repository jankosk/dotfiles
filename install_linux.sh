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

# 1. Install Zsh, system dependencies via APT
echo "Installing Zsh, and system dependencies..."
sudo apt update && sudo apt install -y zsh curl unzip

# 2. Change default shell to Zsh
if [ "$SHELL" != "$(which zsh)" ]; then
	echo "Changing default shell to Zsh..."
	chsh -s "$(which zsh)"
fi

# Install Zsh Autosuggestions
echo "Installing zsh-autosuggestions..."
mkdir -p "$HOME/.zsh"
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed, pulling latest..."
    git -C "$HOME/.zsh/zsh-autosuggestions" pull
fi

# 3. Copy dotfiles
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

# 5. Copy config files
echo "Copying config files..."
mkdir -p "$HOME/.config"
copy_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

mkdir -p "$HOME/.config/lazygit"
copy_file "$DOTFILES_DIR/config.yaml" "$HOME/.config/lazygit/config.yaml"

# 6. Copy bin directory
echo "Copying bin directory..."
mkdir -p "$HOME/bin"
cp -r "$DOTFILES_DIR/bin/"* "$HOME/bin/"
chmod +x "$HOME/bin/"*

# 7. Install Devbox
echo "Installing Devbox (and Nix if required)..."
if ! command -v devbox &> /dev/null; then
	curl -fsSL https://get.jetify.com/devbox | bash
fi

# 8. Install CLI tools globally from devbox.json
echo "Installing CLI tools from devbox.json..."
mkdir -p "$HOME/.local/share/devbox/global/default"

# Copy devbox.json into the Devbox global directory
cp "$DOTFILES_DIR/devbox.json" "$HOME/.local/share/devbox/global/default/devbox.json"

# Temporarily navigate to the global directory to force a clean install
pushd "$HOME/.local/share/devbox/global/default" > /dev/null
devbox install
popd > /dev/null

echo "Installation complete! Restart your terminal."
