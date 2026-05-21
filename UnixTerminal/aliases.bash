# TerminalConfiguration  bash wrapper for shared aliases

# zoxide (shell-specific)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

# Resolve path to repo and shared aliases relative to this file
export TC_REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd .. && pwd )"
COMMON_ALIASES="$TC_REPO_ROOT/Common/aliases.common.sh"
if [ -f "$COMMON_ALIASES" ]; then
  # shellcheck disable=SC1090
  source "$COMMON_ALIASES"
else
  echo "[TerminalConfiguration] Warning: missing $COMMON_ALIASES" >&2
fi
