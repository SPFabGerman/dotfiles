# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}



alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gau='git add --update'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbr='git branch --remote'

alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit -v -a'
alias gcam='git commit -a -m'

function gclcd() {
  command git clone --recurse-submodules "$@"
  [[ -d "$_" ]] && cd "$_" || cd "${${_:t}%.git}"
}
compdef _git gclcd=git-clone

alias gcl='git clone --recurse-submodules'

alias gco='git checkout'
alias gcob='git checkout -b'
alias gcot='git checkout -t'
alias gcom='git checkout $(git_main_branch)'

alias gd='git diff'
alias gdc='git diff --cached'
alias gds='git diff --staged'
alias gdup='git diff @{upstream}'
alias gdw='git diff --word-diff'

alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10' \
alias gfo='git fetch origin'

alias gg='git graph'
alias gga='git graph --all'

alias gl='git log'
alias gl1='git log -1'
alias gla='git log --all'
alias glo='git log --oneline'
alias glao='git log --all --oneline'

alias gm='git merge'
alias gma='git merge --abort'

alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpu='git push --set-upstream'
alias gpa='git push --all'
alias gpt='git push --tags'

alias gpl='git pull'
alias gplo='git pull origin'

alias gpr='git pull --rebase'
alias gpro='git pull --rebase origin'

alias gr='git remote'
alias gra='git remote add'
alias grr='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'

alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'

alias gre='git reset'
alias greh='git reset --hard'

alias grm='git rm'
alias grmc='git rm --cached'

alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'

alias gst='git status'

alias gqs='git quicksave'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

