# PROMPT
eval "$(starship init zsh)"

# HISTORY
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
# Share history between sessions
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# FZF
source <(fzf --zsh)

# UTILS
source ~/utils.zsh

# PATHS
export PATH="$HOME/bin:$PATH"
