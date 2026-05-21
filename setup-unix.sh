#!/usr/bin/env bash
set -euo pipefail

# TerminalConfiguration macOS bootstrap script
# This sets up a modern terminal environment on macOS using iTerm2 + oh-my-posh + common CLI tools.
# Safe to re-run; it will skip already-installed items and avoid duplicate config lines.

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script supports macOS only." >&2
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSH_CONFIG_DEFAULT="$REPO_ROOT/WindowsTerminal/PoshConfigs/material.json"
POSH_THEMES_DIR="$HOME/.poshthemes"
POSH_TARGET_CONFIG="$POSH_THEMES_DIR/terminal.omp.json"
ZSHRC="$HOME/.zshrc"
BASHRC="$HOME/.bashrc"
BASH_PROFILE="$HOME/.bash_profile"
DOTFILES_DIR="$REPO_ROOT/UnixTerminal/dotfiles"
DOT_BASH_PROFILE_SRC="$DOTFILES_DIR/.bash_profile"
DOT_BASHRC_SRC="$DOTFILES_DIR/.bashrc"

COMMON_FONTS_DIR="$REPO_ROOT/Common/nerdfonts"
LEGACY_FONTS_DIR="$REPO_ROOT/WindowsTerminal/nerdfonts"
if [[ -d "$COMMON_FONTS_DIR" ]]; then
  FONTS_SRC_DIR="$COMMON_FONTS_DIR"
else
  FONTS_SRC_DIR="$LEGACY_FONTS_DIR"
fi
FONTS_DEST_DIR="$HOME/Library/Fonts"

say() { echo -e "\033[1;32m==>\033[0m $*"; }
warn() { echo -e "\033[1;33m[warning]\033[0m $*"; }
info() { echo -e "\033[0;36m$*\033[0m"; }

ensure_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    say "Homebrew not found; installing..."
    # Require admin for interactive install so sudo can prompt if needed
    if id -Gn "$USER" | tr ' ' '\n' | grep -qx admin; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      # Set up brew in PATH for Apple Silicon / Intel
      if [[ -d "/opt/homebrew/bin" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -d "/usr/local/bin" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    else
      warn "Current user is not an Administrator. Please install Homebrew with an admin user, then re-run this script."
      warn "Manual install: /bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
      exit 1
    fi
  fi
}

ensure_cask_fonts_tap() {
  # No-op: homebrew/cask-fonts tap is deprecated. Font casks are now in core casks.
  info "Skipping cask-fonts tap (deprecated); installing fonts from core casks."
  return 0
}


brew_install() {
  local pkg="$1"
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    info "brew: $pkg already installed"
  else
    say "Installing $pkg"
    brew install "$pkg"
  fi
}

brew_install_cask() {
  local cask="$1"
  if brew list --cask "$cask" >/dev/null 2>&1; then
    info "brew cask: $cask already installed"
    return 0
  fi
  # Handle common case: app already installed outside Homebrew
  local app_path=""
  case "$cask" in
    iterm2)
      app_path="/Applications/iTerm.app";;
  esac
  if [[ -n "$app_path" && -d "$app_path" ]]; then
    info "Detected $app_path on disk; skipping brew cask $cask"
    return 0
  fi
  say "Installing cask $cask"
  brew install --cask "$cask" || { warn "brew cask install failed for $cask (may already be present). Continuing."; return 0; }
}

append_once() {
  local line="$1"
  local file="$2"
  touch "$file"
  if ! grep -Fq "$line" "$file"; then
    echo "$line" >>"$file"
  fi
}

prune_tc_blocks() {
  # Strip every "# TerminalConfiguration (...)" marker line and the immediate
  # line that follows it. Makes the installer idempotent across repo moves —
  # without this, append_once would leave stale source/settings lines pointing
  # at the previous repo location after the repo is moved.
  local file="$1"
  [[ -f "$file" ]] || return 0
  local tmp
  tmp="$(mktemp)"
  awk '
    /^# TerminalConfiguration \(/ { skip=1; next }
    skip { skip=0; next }
    { print }
  ' "$file" > "$tmp" && mv "$tmp" "$file"
}
ask_yes_no() {
  # $1 question, $2 default (y/n), default n
  local q="$1"; local def="${2:-n}"; local prompt=" [y/N]: "
  if [[ "$def" == "y" || "$def" == "Y" ]]; then prompt=" [Y/n]: "; fi
  local ans
  read -r -p "$q$prompt" ans || true
  ans="${ans:-$def}"
  case "$ans" in
    y|Y) return 0;;
    *) return 1;;
  esac
}

install_bash_it() {
  if [[ ! -d "$HOME/.bash_it" ]]; then
    say "Installing Bash-it"
    git clone --depth=1 https://github.com/Bash-it/bash-it.git "$HOME/.bash_it"
  else
    info "Bash-it already present"
  fi
}

configure_bash() {
  # Configure oh-my-posh, aliases, and bash-it in bash startup files
  local rc
  for rc in "$BASHRC" "$BASH_PROFILE"; do
    append_once "# TerminalConfiguration (oh-my-posh bash, guarded for Bash >= 4)" "$rc"
    append_once 'if [ -n "${BASH_VERSINFO:-}" ] && [ "${BASH_VERSINFO[0]}" -ge 4 ]; then eval "$(oh-my-posh init bash --config ~/.poshthemes/terminal.omp.json)"; fi' "$rc"
    if [[ -f "$REPO_ROOT/UnixTerminal/aliases.bash" ]]; then
      append_once "# TerminalConfiguration (aliases)" "$rc"
      append_once "source \"$REPO_ROOT/UnixTerminal/aliases.bash\"" "$rc"
    fi
    if [[ -d "$HOME/.bash_it" ]]; then
      append_once "export BASH_IT=\"$HOME/.bash_it\"" "$rc"
      append_once "source \"$HOME/.bash_it/bash_it.sh\"" "$rc"
    fi
  done
}

configure_start_dir() {
  # Default to ~/code only when starting at HOME in an interactive shell (zsh only; bash handled via dotfiles)
  append_once "# TerminalConfiguration (default start dir)" "$ZSHRC"
  append_once '[[ -d "$HOME/code" && "$PWD" = "$HOME" && $- = *i* ]] && cd "$HOME/code"' "$ZSHRC"
}


configure_repo_git() {
  # Pin this repo to the personal identity, activate the versioned pre-commit
  # hook, and route ssh through a personal key so the work machine can't
  # accidentally push as the work identity.
  local expected_name="Paul Gradie"
  local expected_email="paul.e.gradie@gmail.com"
  local personal_key="$HOME/.ssh/id_ed25519_personal"

  say "Configuring local git identity and hooks for this repo"
  git -C "$REPO_ROOT" config --local user.name "$expected_name"
  git -C "$REPO_ROOT" config --local user.email "$expected_email"
  git -C "$REPO_ROOT" config --local core.hooksPath ".githooks"

  if [[ -f "$personal_key" ]]; then
    git -C "$REPO_ROOT" config --local core.sshCommand "ssh -i '$personal_key' -o IdentitiesOnly=yes -o IdentityAgent=none"
    info "core.sshCommand set to use $personal_key"
  else
    warn "Personal SSH key not found at $personal_key"
    warn "Generate one and add the .pub to your personal GitHub, then re-run this script:"
    warn "  ssh-keygen -t ed25519 -C \"$expected_email\" -f \"$personal_key\""
    git -C "$REPO_ROOT" config --local --unset core.sshCommand 2>/dev/null || true
  fi
}

install_bash_dotfiles() {
  # Overwrite ~/.bash_profile and ~/.bashrc from repo dotfiles (source of truth)
  if [[ -f "$DOT_BASH_PROFILE_SRC" ]]; then
    say "Installing ~/.bash_profile from repo"
    cp -f "$DOT_BASH_PROFILE_SRC" "$BASH_PROFILE"
  else
    warn "Missing template: $DOT_BASH_PROFILE_SRC"
  fi
  if [[ -f "$DOT_BASHRC_SRC" ]]; then
    say "Installing ~/.bashrc from repo"
    cp -f "$DOT_BASHRC_SRC" "$BASHRC"
  else
    warn "Missing template: $DOT_BASHRC_SRC"
  fi

  # Ensure aliases and functions files exist in HOME sourced by the profile
  if [[ -f "$REPO_ROOT/Common/aliases.common.sh" ]]; then
    cp -f "$REPO_ROOT/Common/aliases.common.sh" "$HOME/.aliases"
  fi
  if [[ -f "$REPO_ROOT/Common/functions.common.sh" ]]; then
    cp -f "$REPO_ROOT/Common/functions.common.sh" "$HOME/.functions"
  else
    : > "$HOME/.functions"
  fi
}



main() {
  say "Bootstrapping macOS terminal environment"

  # Strip any TerminalConfiguration-managed lines from rc files first so a
  # re-run from a new repo location doesn't leave stale source/settings lines
  # pointing at the old path. The append_once calls below re-emit fresh lines
  # using the current $REPO_ROOT.
  for rc in "$ZSHRC" "$BASHRC" "$BASH_PROFILE"; do
    prune_tc_blocks "$rc"
  done

  ensure_homebrew
  brew update
  ensure_cask_fonts_tap

  # Keep sudo alive during the run (one prompt at start, none after)
  if sudo -v; then
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  else
    warn "sudo credentials not cached; proceeding without keep-alive."
  fi


  # Core terminal stack
  brew_install_cask iterm2
  brew_install oh-my-posh

  # Helpful modern CLI tools (lightweight; skip if you prefer to add later)
  brew_install eza
  brew_install fzf
  brew_install ripgrep
  brew_install fd
  brew_install bat
  brew_install zoxide
  brew_install neovim
  brew_install gh

  # Fonts: install a Nerd Font via brew and also copy bundled fonts for convenience
  brew_install_cask font-meslo-lg-nerd-font || true
  mkdir -p "$FONTS_DEST_DIR"
  if [[ -d "$FONTS_SRC_DIR" ]]; then
    say "Copying bundled Nerd Fonts (*.ttf, *.otf) to $FONTS_DEST_DIR (no overwrite)"
    # Copy TTF
    find "$FONTS_SRC_DIR" -type f -name "*.ttf" -print0 | while IFS= read -r -d '' font; do
      dest="$FONTS_DEST_DIR/$(basename "$font")"
      if [[ ! -e "$dest" ]]; then
        cp "$font" "$dest"
      fi
    done
    # Copy OTF
    find "$FONTS_SRC_DIR" -type f -name "*.otf" -print0 | while IFS= read -r -d '' font; do
      dest="$FONTS_DEST_DIR/$(basename "$font")"
      if [[ ! -e "$dest" ]]; then
        cp "$font" "$dest"
      fi
    done
  fi

  # oh-my-posh theme setup (symlink to shared theme for cross-platform consistency)
  mkdir -p "$POSH_THEMES_DIR"
  if [[ -f "$POSH_CONFIG_DEFAULT" ]]; then
    ln -sf "$POSH_CONFIG_DEFAULT" "$POSH_TARGET_CONFIG"
  else
    warn "Default posh config not found at $POSH_CONFIG_DEFAULT"
  fi

  # zsh configuration
  if [[ -z "${SHELL:-}" || "${SHELL}" != *"zsh"* ]]; then
    warn "Default shell is not zsh. macOS uses zsh by default; you can switch with: chsh -s /bin/zsh"
  fi

  append_once "# TerminalConfiguration (oh-my-posh)" "$ZSHRC"
  append_once 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/terminal.omp.json)"' "$ZSHRC"

  # Source repo aliases if present
  if [[ -f "$REPO_ROOT/UnixTerminal/aliases.zsh" ]]; then
    append_once "# TerminalConfiguration (aliases)" "$ZSHRC"
    append_once "source \"$REPO_ROOT/UnixTerminal/aliases.zsh\"" "$ZSHRC"
  fi
  # Add a 'settings' helper to jump to this repo
  append_once "# TerminalConfiguration (settings helper)" "$ZSHRC"
  append_once "settings() { cd \"$REPO_ROOT\"; }" "$ZSHRC"
  # Add to bash rc files as well
  for rc in "$BASHRC" "$BASH_PROFILE"; do
    append_once "# TerminalConfiguration (settings helper)" "$rc"
    append_once "settings() { cd \"$REPO_ROOT\"; }" "$rc"
  done
  # Bash-it installation and managed bash dotfiles
  install_bash_it
  install_bash_dotfiles
  configure_start_dir

  # Pin personal identity + activate versioned pre-commit hook for this repo
  configure_repo_git


  # Offer to automatically start bash only if a compatible bash is available
  # macOS ships Bash 3.2, which is incompatible with some oh-my-posh bash init code (-v operator).
  # We'll prefer Homebrew bash if present, otherwise require Bash >= 4.
  CUR_BASH_VER_STR="$(bash --version 2>/dev/null | head -1 | awk '{print $4}')"
  CUR_BASH_MAJOR="${CUR_BASH_VER_STR%%.*}"
  HOMEBREW_PREFIX="$(brew --prefix)"
  HB_BASH="$HOMEBREW_PREFIX/bin/bash"

  if [[ "${SHELL##*/}" != "bash" ]]; then
    compat_bash=""
    if [[ -x "$HB_BASH" ]]; then
      compat_bash="$HB_BASH"
    elif [[ "${CUR_BASH_MAJOR:-0}" -ge 4 ]]; then
      compat_bash="/bin/bash"
    fi

    if [[ -z "$compat_bash" ]]; then
      warn "Your system bash ($(bash --version | head -1)) is too old for reliable oh-my-posh bash init."
      if ask_yes_no "Install modern Bash via Homebrew and set it as your default shell now?" n; then
        brew_install bash
        HB_BASH="$(brew --prefix)/bin/bash"
        if ! grep -qx "$HB_BASH" /etc/shells 2>/dev/null; then
          say "Adding $HB_BASH to /etc/shells (requires sudo)"
          if ! sudo sh -c "echo $HB_BASH >> /etc/shells"; then
            warn "Failed to add $HB_BASH to /etc/shells; cannot set as default."
          fi
        fi
        if grep -qx "$HB_BASH" /etc/shells 2>/dev/null; then
          chsh -s "$HB_BASH" || warn "chsh failed; you may need to run: chsh -s $HB_BASH"
          compat_bash="$HB_BASH"
        fi
      fi
    fi

    if [[ -n "$compat_bash" ]]; then
      if ask_yes_no "Automatically start bash when opening zsh by adding 'exec bash -l' to ~/.zshrc?" n; then
        append_once "exec bash -l" "$ZSHRC"
        say "Added 'exec bash -l' to $ZSHRC"
      fi
    else
      warn "Keeping zsh as your login shell to ensure Oh My Posh works. You can switch later after installing a modern Bash."
    fi
  fi


  # Optional: fzf key bindings (quiet install; no rc edits)
  if [[ -x "$(brew --prefix)/opt/fzf/install" ]]; then
    "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-bash --no-fish --no-update-rc || true
  fi

  say "Done! Next steps:"
  echo "- For bash: source \"$BASHRC\" or \"$BASH_PROFILE\" (depending on your login shell)"

  echo "- Set iTerm2's font to 'MesloLGM Nerd Font' (or Fira Code Nerd Font) for best glyph support."
  echo "- Restart your terminal or run: source \"$ZSHRC\""
  echo "- You can switch oh-my-posh theme by editing: $POSH_TARGET_CONFIG (symlink to $POSH_CONFIG_DEFAULT)"
}

main "$@"

