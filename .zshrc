# Prompt
# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }
# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '(%b)'
# Set up the prompt (with git branch name)
setopt PROMPT_SUBST
PROMPT='%F{green}%n%{$reset_color%} in %F{blue}${PWD/#$HOME/~}%{$reset_color%} %F{red}${vcs_info_msg_0_}%{$reset_color%} $ '

alias zshconfig="vim ~/.zshrc"
alias whatsmyip="dig +short ANY myip.opendns.com @resolver1.opendns.com"

