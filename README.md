# Dotfiles

## macOS

- `./install_mac.sh`
- Install favorite Nerd Font and use it in the terminal emulator of choice.
- Show hidden files: `defaults write com.apple.finder AppleShowAllFiles YES`
- Enable repeating keys by pressing and holding down keys: `defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false`
- Drag windows from anywhere: `defaults write -g NSWindowShouldDragOnGesture -bool true`
- Save screenshots to specific directory: `defaults write com.apple.screencapture location ~/screenshots && killall SystemUIServer`
- Rebind next application window shortcut: System Preferences > Keyboard > Shortcuts > Keyboard > Move focus to next window
- Rebind change input source: System Preferences > Keyboard > Shortcuts > Input Sources > Select the previous input source
- Key Repeat -> Fast
- Delay Until Repeat -> Short

## Linux

- `./install_linux.sh` (debian based)
- Install favorite Nerd Font and use it in the terminal emulator of choice.

## Node

- `npm completion >> ~/.zshrc`
- `pnpm completion >> ~/.zshrc`
