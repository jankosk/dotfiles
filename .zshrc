source ~/base.zsh

# PROMPT
eval "$(starship init bash)"

# HISTORY
export HISTSIZE=100000
export SAVEHIST=100000
export HISTFILE=~/.zsh_history
# Share history between sessions
setopt SHARE_HISTORY

# FZF
source <(fzf --zsh)

# PATHS
export PATH="$HOME/bin:$PATH"
