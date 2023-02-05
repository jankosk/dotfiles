# Dotfiles

# macOS

- Enable repeating keys by pressing and holding down keys: `defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false`
- Drag windows from anywhere: `defaults write -g NSWindowShouldDragOnGesture -bool true`
- Save screenshots to specific directory: `defaults write com.apple.screencapture location ~/screenshots && killall SystemUIServer`