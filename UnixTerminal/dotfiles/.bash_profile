# ~/.bash_profile – managed by TerminalConfiguration setup-unix.sh
# Source of truth: this file lives in the repo under UnixTerminal/dotfiles/.bash_profile
# It may be overwritten by the installer.

# If a modern Bash is available, init oh-my-posh (guard for Bash >= 4)
if [ -n "${BASH_VERSINFO:-}" ] && [ "${BASH_VERSINFO[0]}" -ge 4 ]; then
  eval "$(oh-my-posh init bash --config ~/.poshthemes/terminal.omp.json)"
fi

# Default start directory: ~/code when launching interactive shell from $HOME
if [[ -d "$HOME/code" && "$PWD" = "$HOME" && $- = *i* ]]; then
  cd "$HOME/code"
fi

# Bash-it (if installed)
export BASH_IT="$HOME/.bash_it"
if [ -s "$BASH_IT/bash_it.sh" ]; then
  source "$BASH_IT/bash_it.sh"
fi

# User aliases and functions
# Probe in priority order: explicit env var, new personal-folder location, legacy location.
for __tc_root in "${TC_REPO_ROOT:-}" "$HOME/code/personal/TerminalConfiguration" "$HOME/code/TerminalConfiguration"; do
  if [ -n "$__tc_root" ] && [ -f "$__tc_root/UnixTerminal/aliases.bash" ]; then
    export TC_REPO_ROOT="$__tc_root"
    source "$__tc_root/UnixTerminal/aliases.bash"
    break
  fi
done
unset __tc_root

# Keep PATH additions from Homebrew if present (non-fatal)
if [ -d "/opt/homebrew/bin" ]; then export PATH="/opt/homebrew/bin:$PATH"; fi
if [ -d "/usr/local/bin" ]; then export PATH="/usr/local/bin:$PATH"; fi

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"           # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
