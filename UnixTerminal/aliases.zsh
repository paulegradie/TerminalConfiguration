# TerminalConfiguration  zsh wrapper for shared aliases

# zoxide (shell-specific)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Resolve path to repo and shared aliases relative to this file
# ${0:A:h} = absolute path to this file's directory (zsh-only)
export TC_REPO_ROOT="${0:A:h}/.."
COMMON_ALIASES="$TC_REPO_ROOT/Common/aliases.common.sh"
if [[ -f "$COMMON_ALIASES" ]]; then
  source "$COMMON_ALIASES"
else
  echo "[TerminalConfiguration] Warning: missing $COMMON_ALIASES" >&2
fi
