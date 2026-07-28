# Initialize Devbox Global Environment
eval "$(devbox global shellenv --init-hook)"

# Prompt
eval "$(starship init zsh)"

# History
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
# Share history between sessions
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Zsh Autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Fzf
source <(fzf --zsh)

# Utils
source ~/utils.zsh

# Paths
export PATH="$HOME/bin:$PATH"
