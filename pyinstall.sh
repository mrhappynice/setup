#!/usr/bin/env bash
set -euo pipefail

say()  { printf "\n==> %s\n" "$*"; }
ok()   { printf "✅ %s\n" "$*"; }
die()  { printf "❌ %s\n" "$*\n" >&2; exit 1; }

# 0) Safety: don't run the whole script as root (pyenv installs to $HOME)
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
  die "Do not run this script as root. Run as your user. The script will use sudo for apt when needed."
fi

# 1) Install build deps (Debian/Ubuntu)
if command -v apt >/dev/null 2>&1; then
  say "Installing build dependencies (Debian/Ubuntu)…"
  sudo apt update
  sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git
  ok "Dependencies installed"
else
  say "Skipping apt dependencies (not a Debian/Ubuntu system)."
fi

# 2) Install pyenv (to $HOME/.pyenv)
say "Installing pyenv…"
curl -fsSL https://pyenv.run | bash
ok "pyenv installed"

# 3) Make pyenv available **now** in this script without sourcing rc files
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Initialize pyenv in this shell (call by absolute path; no reliance on PATH lookups)
if [ -x "$PYENV_ROOT/bin/pyenv" ]; then
  # shellcheck disable=SC1090
  eval "$("$PYENV_ROOT/bin/pyenv" init - bash)"
  ok "pyenv initialized for this session"
else
  die "pyenv binary not found at $PYENV_ROOT/bin/pyenv"
fi

# 4) Idempotently add lines to user shell config files
append_if_missing() {
  local line="$1" file="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  grep -Fqx "$line" "$file" || printf '%s\n' "$line" >> "$file"
}

say "Updating your shell startup files so pyenv loads automatically…"

# For Bash: add to ~/.bashrc (interactive shells)
BASHRC="$HOME/.bashrc"
append_if_missing 'export PYENV_ROOT="$HOME/.pyenv"'             "$BASHRC"
append_if_missing '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' "$BASHRC"
append_if_missing 'eval "$(pyenv init - bash)"'                  "$BASHRC"

# For login shells: ~/.bash_profile if it exists; otherwise ~/.profile
if [ -f "$HOME/.bash_profile" ]; then
  LOGINRC="$HOME/.bash_profile"
else
  LOGINRC="$HOME/.profile"
fi
append_if_missing 'export PYENV_ROOT="$HOME/.pyenv"'             "$LOGINRC"
append_if_missing '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' "$LOGINRC"
append_if_missing 'eval "$(pyenv init - bash)"'                  "$LOGINRC"

# For Zsh users (if ~/.zshrc exists)
if [ -f "$HOME/.zshrc" ]; then
  ZSHRC="$HOME/.zshrc"
  append_if_missing 'export PYENV_ROOT="$HOME/.pyenv"'           "$ZSHRC"
  append_if_missing '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' "$ZSHRC"
  append_if_missing 'eval "$(pyenv init - zsh)"'                 "$ZSHRC"
fi

ok "Shell configuration updated"

# 5) Install and set Python
PY_VERSION="3.12.5"
say "Installing Python $PY_VERSION via pyenv… (this may take a while)"
pyenv install -s "$PY_VERSION"   # -s = skip if already installed
ok "Python $PY_VERSION installed"

say "Setting global Python to $PY_VERSION…"
pyenv global "$PY_VERSION"
ok "Global Python set"

# Optionally set local version in the current directory (comment out if not desired)
say "Setting local Python to $PY_VERSION in current directory…"
pyenv local "$PY_VERSION"
ok "Local Python set"

say "Verifying…"
python -V
pyenv versions
ok "All done! Open a new terminal (or run: exec \$SHELL -l) for shells to pick up the changes."
