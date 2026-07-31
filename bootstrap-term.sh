#!/usr/bin/env bash
# Terminal-only bootstrap: fish, starship, wezterm, neovim (NvChad), fonts.
#
# Usage (from anywhere):
#   curl -fsSL https://raw.githubusercontent.com/AdiCahyaSaputra/dotfiles/main/bootstrap-term.sh | bash
#
# Or after cloning:
#   ./bootstrap-term.sh
#   ./bootstrap-term.sh --yes          # non-interactive (chsh fish, skip prompts)
#   DOTFILES_DIR=~/my-dots ./bootstrap-term.sh
#
set -euo pipefail

REPO_URL="${DOTFILES_REPO:-https://github.com/AdiCahyaSaputra/dotfiles.git}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
PACKAGES=(fish starship wezterm nvchad)
ASSUME_YES=0

for arg in "$@"; do
  case "$arg" in
    -y|--yes) ASSUME_YES=1 ;;
    -h|--help)
      sed -n '2,12p' "$0"
      exit 0
      ;;
  esac
done

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

confirm() {
  local prompt="$1"
  if [[ "$ASSUME_YES" -eq 1 ]]; then
    return 0
  fi
  if [[ ! -t 0 ]]; then
    # Piped curl|bash — default to yes for install path, no for chsh
    return 1
  fi
  read -r -p "$prompt [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ---------------------------------------------------------------------------
# OS detection
# ---------------------------------------------------------------------------
OS=unknown
ID=
ID_LIKE=

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)
    OS=linux
    if [[ -f /etc/os-release ]]; then
      # shellcheck disable=SC1091
      . /etc/os-release
      ID="${ID:-}"
      ID_LIKE="${ID_LIKE:-}"
    fi
    ;;
  *) die "Unsupported OS: $(uname -s)" ;;
esac

is_debian() {
  [[ "$ID" == "debian" || "$ID" == "ubuntu" || "$ID" == "kali" || "$ID" == "linuxmint" \
    || "$ID_LIKE" == *debian* || "$ID_LIKE" == *ubuntu* ]]
}

is_arch() {
  [[ "$ID" == "arch" || "$ID" == "endeavouros" || "$ID" == "manjaro" || "$ID_LIKE" == *arch* ]]
}

# ---------------------------------------------------------------------------
# Package installs
# ---------------------------------------------------------------------------
install_debian_base() {
  log "Installing base packages (apt)…"
  sudo apt-get update -y
  sudo apt-get install -y \
    git curl unzip stow fish zoxide fontconfig \
    ca-certificates gnupg
}

install_arch_base() {
  log "Installing base packages (pacman)…"
  sudo pacman -Syu --needed --noconfirm \
    git curl unzip stow fish zoxide fontconfig neovim starship wezterm
}

install_macos_base() {
  if ! have brew; then
    die "Homebrew not found. Install from https://brew.sh then re-run."
  fi
  log "Installing base packages (brew)…"
  brew install git stow fish starship zoxide neovim
  brew install --cask wezterm
}

install_starship() {
  if have starship; then
    ok "starship already installed ($(starship --version 2>/dev/null | head -1))"
    return
  fi
  log "Installing starship…"
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
  ok "starship installed"
}

install_zoxide() {
  if have zoxide; then
    ok "zoxide already installed"
    return
  fi
  log "Installing zoxide…"
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
  ok "zoxide installed"
}

install_neovim() {
  if have nvim; then
    local ver
    ver="$(nvim --version | head -1)"
    ok "neovim already installed ($ver)"
    # Warn if very old (< 0.9) — NvChad needs a recent nvim
    if ! nvim --version | head -1 | grep -qE 'v0\.(9|[1-9][0-9])|v[1-9]'; then
      warn "Neovim looks old; NvChad may need 0.9+. Consider a newer build."
    fi
    return
  fi

  case "$OS" in
    macos)
      brew install neovim
      ;;
    linux)
      if is_arch; then
        sudo pacman -S --needed --noconfirm neovim
      elif is_debian; then
        log "Installing neovim (apt)…"
        sudo apt-get install -y neovim || true
        if ! have nvim || ! nvim --version | head -1 | grep -qE 'v0\.(9|[1-9][0-9])|v[1-9]'; then
          warn "apt neovim is missing/old — installing AppImage to ~/.local/bin/nvim"
          mkdir -p "$HOME/.local/bin"
          local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
          curl -fsSL "$url" -o "$HOME/.local/bin/nvim.appimage"
          chmod +x "$HOME/.local/bin/nvim.appimage"
          # Extract if FUSE unavailable (common on VMs)
          if ! "$HOME/.local/bin/nvim.appimage" --version >/dev/null 2>&1; then
            cd "$HOME/.local/bin"
            ./nvim.appimage --appimage-extract >/dev/null
            ln -sfn "$HOME/.local/bin/squashfs-root/usr/bin/nvim" "$HOME/.local/bin/nvim"
            rm -f nvim.appimage
          else
            ln -sfn "$HOME/.local/bin/nvim.appimage" "$HOME/.local/bin/nvim"
          fi
          export PATH="$HOME/.local/bin:$PATH"
        fi
      else
        die "Don't know how to install neovim on $ID"
      fi
      ;;
  esac
  ok "neovim ready ($(nvim --version | head -1))"
}

install_wezterm() {
  if have wezterm; then
    ok "wezterm already installed"
    return
  fi

  case "$OS" in
    macos)
      brew install --cask wezterm
      ;;
    linux)
      if is_arch; then
        sudo pacman -S --needed --noconfirm wezterm
      elif is_debian; then
        log "Installing WezTerm (official apt repo)…"
        curl -fsSL https://apt.fury.io/wez/gpg.key \
          | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' \
          | sudo tee /etc/apt/sources.list.d/wezterm.list >/dev/null
        sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
        sudo apt-get update -y
        sudo apt-get install -y wezterm
      else
        warn "Skipping WezTerm install on $ID — install manually: https://wezfurlong.org/wezterm/install/linux.html"
        return
      fi
      ;;
  esac
  ok "wezterm installed"
}

install_nerd_font() {
  local font_dir="$HOME/.local/share/fonts"
  local marker="$font_dir/JetBrainsMonoNerdFont-Regular.ttf"

  if [[ -f "$marker" ]] || fc-list 2>/dev/null | grep -qi 'JetBrainsMono.*Nerd'; then
    ok "JetBrainsMono Nerd Font already present"
    return
  fi

  log "Installing JetBrainsMono Nerd Font…"
  mkdir -p "$font_dir"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
    -o "$tmp/JetBrainsMono.zip"
  unzip -qo "$tmp/JetBrainsMono.zip" -d "$font_dir"
  rm -rf "$tmp"
  if have fc-cache; then
    fc-cache -f "$font_dir" >/dev/null 2>&1 || true
  fi
  ok "Nerd Font installed → $font_dir"
}

# ---------------------------------------------------------------------------
# Dotfiles + stow
# ---------------------------------------------------------------------------
ensure_repo() {
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"

  # Running from a local checkout of this repo
  if [[ -n "$script_dir" && -d "$script_dir/fish" && -d "$script_dir/starship" ]]; then
    DOTFILES_DIR="$script_dir"
    ok "Using local repo: $DOTFILES_DIR"
    return
  fi

  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    log "Updating existing clone at $DOTFILES_DIR…"
    git -C "$DOTFILES_DIR" pull --ff-only || warn "git pull failed — using existing tree"
  else
    log "Cloning $REPO_URL → $DOTFILES_DIR…"
    git clone "$REPO_URL" "$DOTFILES_DIR"
  fi
  ok "Repo ready: $DOTFILES_DIR"
}

backup_if_needed() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    local bak="${target}.bak.$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing $target → $bak"
    mv "$target" "$bak"
  fi
}

stow_packages() {
  have stow || die "stow is required but not installed"

  mkdir -p "$HOME/.config" "$HOME/.local/bin"

  # Conflicts that block stow
  backup_if_needed "$HOME/.config/fish"
  backup_if_needed "$HOME/.config/starship.toml"
  backup_if_needed "$HOME/.config/nvim"
  backup_if_needed "$HOME/.wezterm.lua"

  log "Stowing: ${PACKAGES[*]}"
  (
    cd "$DOTFILES_DIR"
    stow -t "$HOME" -R "${PACKAGES[@]}"
  )
  ok "Configs linked into $HOME"
}

set_fish_shell() {
  local fish_path
  fish_path="$(command -v fish)" || {
    warn "fish not on PATH — skip chsh"
    return
  }

  if [[ "${SHELL:-}" == "$fish_path" ]]; then
    ok "Default shell already fish"
    return
  fi

  if ! grep -qxF "$fish_path" /etc/shells 2>/dev/null; then
    log "Adding $fish_path to /etc/shells…"
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$ASSUME_YES" -eq 1 ]] || confirm "Set fish as your default shell?"; then
    chsh -s "$fish_path"
    ok "Default shell → $fish_path (re-login to apply)"
  else
    warn "Skipped chsh — run: chsh -s $fish_path"
  fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
main() {
  log "Terminal bootstrap starting (OS=$OS${ID:+ id=$ID})"

  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  case "$OS" in
    macos)
      install_macos_base
      ;;
    linux)
      if is_arch; then
        install_arch_base
      elif is_debian; then
        install_debian_base
        install_starship
        install_zoxide
        install_neovim
        install_wezterm
      else
        die "Unsupported Linux distro: ${ID:-unknown}. Install fish/stow/starship/wezterm/nvim manually, then re-run from a clone."
      fi
      ;;
  esac

  # Arch/macOS already pull most tools via package manager; fill gaps
  if is_arch || [[ "$OS" == macos ]]; then
    :
  fi
  have starship || install_starship
  have zoxide || install_zoxide
  have nvim || install_neovim
  have wezterm || install_wezterm

  install_nerd_font
  ensure_repo
  stow_packages
  set_fish_shell

  cat <<EOF

$(ok "Terminal setup complete.")

  fish     → $(command -v fish 2>/dev/null || echo missing)
  starship → $(command -v starship 2>/dev/null || echo missing)
  wezterm  → $(command -v wezterm 2>/dev/null || echo missing)
  nvim     → $(command -v nvim 2>/dev/null || echo missing)  (NvChad configs stowed)
  zoxide   → $(command -v zoxide 2>/dev/null || echo missing)

Open WezTerm (or run \`fish\`), then launch \`nvim\` once so NvChad/lazy.nvim can install plugins.

EOF
}

main "$@"
