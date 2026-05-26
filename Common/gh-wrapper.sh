# TerminalConfiguration — `gh` wrapper that auto-selects which GitHub
# account to use based on the current repo's `origin` owner.
#
# Why: the GitHub CLI has one "active" account at a time, but most of us
# have at least two identities (personal + work). Without this wrapper
# you have to remember to `gh auth switch` every time you cross between
# `~/code/personal/...` and `~/code/work/...`, which nobody actually
# does, which means PR creation silently uses the wrong account.
#
# How: on every `gh` invocation this function:
#   1. Sources Common/gh-identity.local (gitignored, holds your PATs)
#   2. Reads `git remote get-url origin` to learn the repo owner
#   3. Calls tc_gh_route_owner_to_token "$owner" (defined in
#      gh-identity.local) to pick the right token
#   4. Invokes the real `gh` with `GH_TOKEN=<that token>` for just
#      this one call — no global state is mutated
#
# Escape hatches:
#   GH_TOKEN_OVERRIDE=$GH_TOKEN_PERSONAL gh ...   # force a specific token
#   TC_GH_DEBUG=1 gh ...                          # print routing decision
#
# Fallthrough: if gh-identity.local is missing or unreadable, the
# wrapper just calls the real `gh` with whatever it would have used
# anyway (i.e. the currently-active account from `gh auth login`).

# Resolve the identity file path. TC_REPO_ROOT is set by
# aliases.zsh / aliases.bash. Fall back to the canonical personal
# location so this still works if sourced standalone.
__tc_gh_identity_file() {
  printf '%s/Common/gh-identity.local' \
    "${TC_REPO_ROOT:-$HOME/code/personal/TerminalConfiguration}"
}

# Sources gh-identity.local. Returns 0 if loaded, 1 if missing.
__tc_gh_load_identities() {
  local f
  f=$(__tc_gh_identity_file)
  if [ -r "$f" ]; then
    # shellcheck disable=SC1090
    . "$f"
    return 0
  fi
  return 1
}

# Print the GitHub owner of the cwd's origin, or empty if cwd is not a
# git repo / has no origin remote.
# Handles both ssh (git@github.com:owner/repo.git) and https
# (https://github.com/owner/repo[.git]) URL forms.
__tc_gh_owner_from_cwd() {
  local url
  url=$(git remote get-url origin 2>/dev/null) || return 1
  printf '%s' "$url" | sed -E 's#(.*[:/])([^/]+)/[^/]+(\.git)?$#\2#'
}

gh() {
  # Manual one-shot override always wins.
  if [ -n "${GH_TOKEN_OVERRIDE:-}" ]; then
    [ -n "${TC_GH_DEBUG:-}" ] && echo "[tc-gh] using GH_TOKEN_OVERRIDE" >&2
    GH_TOKEN="$GH_TOKEN_OVERRIDE" command gh "$@"
    return $?
  fi

  if ! __tc_gh_load_identities; then
    [ -n "${TC_GH_DEBUG:-}" ] && \
      echo "[tc-gh] no $(__tc_gh_identity_file) — using default gh auth" >&2
    command gh "$@"
    return $?
  fi

  # Caller must have provided tc_gh_route_owner_to_token in
  # gh-identity.local. If they didn't, fall through gracefully.
  if ! command -v tc_gh_route_owner_to_token >/dev/null 2>&1; then
    [ -n "${TC_GH_DEBUG:-}" ] && \
      echo "[tc-gh] gh-identity.local missing tc_gh_route_owner_to_token — using default gh auth" >&2
    command gh "$@"
    return $?
  fi

  local owner token
  owner=$(__tc_gh_owner_from_cwd 2>/dev/null || true)
  token=$(tc_gh_route_owner_to_token "$owner" 2>/dev/null || true)

  if [ -n "${TC_GH_DEBUG:-}" ]; then
    if [ -n "$owner" ]; then
      echo "[tc-gh] owner=$owner → routed token (${#token} chars)" >&2
    else
      echo "[tc-gh] no origin in cwd → fallback identity (${#token} chars)" >&2
    fi
  fi

  if [ -n "$token" ]; then
    GH_TOKEN="$token" command gh "$@"
  else
    # Routing function returned empty — let gh figure it out.
    command gh "$@"
  fi
}
