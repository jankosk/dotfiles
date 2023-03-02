function preman() {
	man -t $1 | open -fa "Preview"
}

# Aliases
alias aliases="grep 'alias ' ~/base.zsh"
alias updatezshrc="source ~/.zshrc"
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ls="ls --color=auto"
alias ll="ls -lath"

