# macOS only
function htman() {
  if [[ -z "$1" ]]; then
    echo "Usage: oman <command>"
    return 1
  fi
  man -w "$1" >/dev/null 2>&1 || { echo "Man page for '$1' not found."; return 1; }
  local tmpfile
  tmpfile="$(mktemp "/tmp/$1.XXXXXX.html")" || return 1
  man "$1" | man2html > "$tmpfile" || return 1
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

function gbp {
  git fetch --prune --prune-tags                              # prune remotes & tags
  D=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
  [ -z "$D" ] && D=master                                     # fallback if no origin/HEAD
  H=$(git rev-parse --abbrev-ref HEAD)                        # current branch
  C=$(date -v-30d +%s 2>/dev/null || date -d '30 days ago' +%s) # 30d cutoff (mac/Linux)
  git for-each-ref --format='%(refname:short) %(committerdate:unix)' refs/heads | \
  while read b t; do                                          # iterate branches
    case "$b" in
      "$H"|"$D"|main|master|dev|prod) continue ;;             # keep common special branches
    esac
    echo "Deleting $b"                                        # log deletion
    git branch -D -- "$b"                                     # force delete
  done
}

# Aliases
alias aliases="grep 'alias ' ~/utils.zsh"
alias updatezshrc="source ~/.zshrc"
alias whatsmyip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ls="ls --color=auto"
alias ll="ls -lath"
# macOS only
alias nosleep="caffeinate -i"
