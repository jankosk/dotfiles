#!/bin/bash

set -e

OS_TYPE=$(uname -s)

copy_file() {
	local source="$1"
	local target="$2"
	if [ -e "$target" ]; then
		mv "$target" "$target.old"
	fi
	cp "$source" "$target"
}

# Copy dotfiles
echo "Copying dotfiles..."
copy_file ".zshrc" "$HOME/.zshrc"
copy_file ".vimrc" "$HOME/.vimrc"
copy_file ".tmux.conf" "$HOME/.tmux.conf"
copy_file ".gitconfig" "$HOME/.gitconfig"
copy_file ".psqlrc" "$HOME/.psqlrc"
copy_file "utils.zsh" "$HOME/utils.zsh"

# Git identity
echo "Configuring Git identity..."
read -p "Enter your full name for Git: " git_name
read -p "Enter your email address for Git: " git_email
git config --file "$HOME/.gitconfig" user.name "$git_name"
git config --file "$HOME/.gitconfig" user.email "$git_email"

# Copy starship config
mkdir -p "$HOME/.config"
copy_file "starship.toml" "$HOME/.config/starship.toml"

# Copy bin directory
mkdir -p "$HOME/bin"
cp -r bin/* "$HOME/bin/"
chmod +x "$HOME/bin/"*

# Install Homebrew if not found
if ! command -v brew &> /dev/null; then
	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	if [[ "$OS_TYPE" == "Darwin" ]]; then
		BREW_PATH="/opt/homebrew/bin/brew"
	else
		BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
	fi
	eval "$($BREW_PATH shellenv)"
	# Add brew shellenv to start of .zshrc
	(echo "eval \"\$($BREW_PATH shellenv)\""; cat "$HOME/.zshrc") | tee "$HOME/.zshrc" > /dev/null
fi

# Install Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --file=Brewfile
echo "Homebrew packages installed"

echo "Installation complete!"
echo "Restart your terminal or run: source ~/.zshrc"
