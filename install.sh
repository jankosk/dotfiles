#!/bin/bash

set -e

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
fi

# Install Homebrew packages
echo "Installing Homebrew packages..."
brew bundle --file=Brewfile
echo "Homebrew packages installed"

echo "Installation complete!"
echo "Restart your terminal or run: source ~/.zshrc"
