# Dotfiles

# macOS

- Show hidden files: `defaults write com.apple.finder AppleShowAllFiles YES`
- Enable repeating keys by pressing and holding down keys: `defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false`
- Drag windows from anywhere: `defaults write -g NSWindowShouldDragOnGesture -bool true`
- Save screenshots to specific directory: `defaults write com.apple.screencapture location ~/screenshots && killall SystemUIServer`
- Rebind next application window shortcut: System Preferences > Keyboard > Shortcuts > Keyboard > Move focus to next window
- Key Repeat -> Fast
- Delay Until Repeat -> Short


# Brew

- `brew bundle --file Brewfile`


# Node

- `npm completion >> ~/.zshrc`