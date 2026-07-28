# macOS only
function htman() {
  if ! man "$1" > /dev/null 2>&1; then
    echo "Man page for '$1' not found."
    return 1
  fi
  tmpfile=/tmp/"$1".html
  if [ ! -e "$tmpfile" ]; then
    tmpfile=$(mktemp /tmp/"$1".html)
    man "$1" | man2html > "$tmpfile"
  fi
  open "$tmpfile"
}

# online man
function oman() {
  if [[ -z "$1" ]]; then
    echo "Usage: oman <command>"
    return 1
  fi
  local base_url="https://man.cx/"
  open "${base_url}${1}"
}

# better git worktree support for lazygit
function lg() {
  export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
  lazygit "$@"
  if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
    cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
    rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
  fi
}

function uuid() {
  echo $(uuidgen | tr "[:upper:]" "[:lower:]")
}

# Aliases
alias aliases="grep 'alias ' ~/utils.zsh"
alias updatezshrc="source ~/.zshrc"
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ls="ls --color=auto"
alias ll="ls -lath"
# macOS only
alias nosleep="caffeinate -i"
