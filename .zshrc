source ~/base.zsh

# Prompt
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'
PROMPT='%F{green}%n%f in %F{cyan}${PWD/#$HOME/~}%f %F{red}${vcs_info_msg_0_}%f $ '

# PATHS
export PATH="$HOME/bin:$PATH"


