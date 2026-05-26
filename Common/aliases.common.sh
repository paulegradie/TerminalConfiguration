# TerminalConfiguration — shared aliases/functions for zsh and bash
# Keep this POSIX-ish. Shell-specific init stays in aliases.zsh / aliases.bash.

# Guard: load once
if [ -n "${__TC_COMMON_ALIASES_SOURCED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
__TC_COMMON_ALIASES_SOURCED=1

# Core
alias ll='eza -lah --group-directories-first --icons=auto'
alias ls='eza --color=auto --icons=auto'
alias la='eza -a --icons=auto'
alias l='eza -lh --icons=auto'
alias cat='bat -pp'

# Windows muscle memory
alias cls='clear'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Jump to repo root. Uses TC_REPO_ROOT if set, else probes the new personal
# location first, then the legacy location, then $HOME as a last resort.
settings() {
  local target
  if [ -n "${TC_REPO_ROOT:-}" ] && [ -d "$TC_REPO_ROOT" ]; then
    target="$TC_REPO_ROOT"
  elif [ -d "$HOME/code/personal/TerminalConfiguration" ]; then
    target="$HOME/code/personal/TerminalConfiguration"
  elif [ -d "$HOME/code/TerminalConfiguration" ]; then
    target="$HOME/code/TerminalConfiguration"
  else
    target="$HOME"
  fi
  cd "$target"
}

# Git basics
alias g='git'
alias gst='git status'
alias ga='git add'
alias gaa='git add --all'

# Commit with optional PLA-<number> prefix derived from branch name like 123-some-thing
gcm() {
  local msg="$*"
  local branch number
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  number=$(printf "%s" "$branch" | sed -nE 's/^([0-9]+)-[A-Za-z0-9-]+.*/\1/p')
  if [ -n "$number" ]; then
    git commit -m "PLA-$number $msg"
  else
    git commit -m "$msg"
  fi
}
# Convenience commit-all alias
alias gcam='git commit -a -m'

# Checkout with -b branch creation support
alias gb='git branch'
alias gbr='git branch -r'

gco() {
  if [ "$1" = "-b" ]; then
    git checkout -b "$2"
  else
    git checkout "$1"
  fi
}
alias gcb='git checkout -b'

alias gpl='git pull'
alias gp='git pull'
alias gps='git push'
alias gpsu='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'

# Extra Git helpers
alias gau='git add -u'

gpo()  { local b="${1:-$(git rev-parse --abbrev-ref HEAD)}"; git push origin "$b"; }

gpfo() { local b="${1:-$(git rev-parse --abbrev-ref HEAD)}"; git push -f origin "$b"; }

gbd()  { git branch -d "$1"; }

gbdf() { git branch -D "$1"; }

# Find / ripgrep helpers
alias rgp='rg --hidden --glob "!node_modules" --glob "!.git"'

# Kubernetes (optional)
alias k='kubectl'

# VS Code
alias c.='code .'

# Extra nav shortcuts
alias lsa='eza -lah --icons=auto'
alias home='cd "$HOME/code"'
# Tilt Prompt Library Plugins shortcut
alias plib='cd "$HOME/code/work/TiltPromptLibraryPlugins"'
# Tilt empower app shortcut
alias tilt='cd "$HOME/code/work/empower-app"'



# Open current shell profile in VS Code (fallback to $EDITOR)
prof() {
  if command -v code >/dev/null 2>&1; then
    if [ "${SHELL##*/}" = "zsh" ]; then code ~/.zshrc; else code ~/.bash_profile; fi
  else
    if [ "${SHELL##*/}" = "zsh" ]; then ${EDITOR:-vi} ~/.zshrc; else ${EDITOR:-vi} ~/.bash_profile; fi
  fi
}

# GitHub identity routing. The wrapper defines a `gh` shell function
# that picks the right token from Common/gh-identity.local based on
# the current repo's `origin` owner. See gh-identity.local.template
# for setup.
__TC_GH_WRAPPER="${TC_REPO_ROOT:-$HOME/code/personal/TerminalConfiguration}/Common/gh-wrapper.sh"
if [ -f "$__TC_GH_WRAPPER" ]; then
  # shellcheck disable=SC1090
  . "$__TC_GH_WRAPPER"
fi
unset __TC_GH_WRAPPER

