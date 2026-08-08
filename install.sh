#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_file() {
	local source="$1"
	local target="$2"
	if [ -L "$target" ]; then
		rm "$target"
	elif [ -e "$target" ]; then
		local timestamp
		timestamp="$(date +%Y%m%d-%H%M%S)"
		mv "$target" "$target.old.$timestamp"
	fi
	ln -s "$source" "$target"
}

install_linux_dependencies() {
	echo "Installing Zsh and system dependencies..."
	sudo apt update && sudo apt install -y zsh curl unzip

	if [ "$SHELL" != "$(command -v zsh)" ]; then
		echo "Changing default shell to Zsh..."
		chsh -s "$(command -v zsh)"
	fi
}

ensure_homebrew() {
	if command -v brew > /dev/null 2>&1; then
		return
	fi

	echo "Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if [ -x "/opt/homebrew/bin/brew" ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
		if ! grep -q '/opt/homebrew/bin/brew shellenv' "$HOME/.zshrc" 2>/dev/null; then
			echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
		fi
	elif [ -x "/usr/local/bin/brew" ]; then
		eval "$(/usr/local/bin/brew shellenv)"
		if ! grep -q '/usr/local/bin/brew shellenv' "$HOME/.zshrc" 2>/dev/null; then
			echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zshrc"
		fi
	fi
}

install_zsh_autosuggestions() {
	echo "Checking zsh-autosuggestions..."
	mkdir -p "$HOME/.zsh"
	if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
		git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
	else
		echo "zsh-autosuggestions already installed, pulling latest..."
		git -C "$HOME/.zsh/zsh-autosuggestions" pull
	fi
}

copy_dotfiles() {
	echo "Linking dotfiles..."
	link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
	link_file "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
	link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
	link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
	link_file "$DOTFILES_DIR/.psqlrc" "$HOME/.psqlrc"
	link_file "$DOTFILES_DIR/utils.zsh" "$HOME/utils.zsh"
}

configure_git_identity() {
	echo "Configuring Git identity..."
	read -r -p "Enter your full name for Git: " git_name
	read -r -p "Enter your email address for Git: " git_email
	git config --file "$HOME/.gitconfig" user.name "$git_name"
	git config --file "$HOME/.gitconfig" user.email "$git_email"
}

copy_configs() {
	echo "Linking config files..."
	mkdir -p "$HOME/.config"
	link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
	link_file "$DOTFILES_DIR/lazygit" "$HOME/.config/lazygit"
	link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
}

copy_bin() {
	echo "Copying bin directory..."
	mkdir -p "$HOME/bin"
	cp -r "$DOTFILES_DIR/bin/"* "$HOME/bin/"
	chmod +x "$HOME/bin/"*
}

install_devbox() {
	echo "Installing Devbox..."
	if ! command -v devbox > /dev/null 2>&1; then
		curl -fsSL https://get.jetify.com/devbox | bash
	fi
}

install_devbox_global_tools() {
	echo "Installing CLI tools from devbox.json..."
	mkdir -p "$HOME/.local/share/devbox/global/default"
	cp "$DOTFILES_DIR/devbox.json" "$HOME/.local/share/devbox/global/default/devbox.json"

	pushd "$HOME/.local/share/devbox/global/default" > /dev/null
	devbox install
	popd > /dev/null
}

OS="$(uname -s)"

if [ "$OS" = "Linux" ]; then
	install_linux_dependencies
elif [ "$OS" = "Darwin" ]; then
	ensure_homebrew
	echo "Installing Homebrew packages..."
	brew bundle --file="$DOTFILES_DIR/Brewfile"
else
	echo "Unsupported OS: $OS"
	exit 1
fi

install_zsh_autosuggestions
copy_dotfiles
configure_git_identity
copy_configs
copy_bin
install_devbox
install_devbox_global_tools

echo "Installation complete! Restart your terminal."
