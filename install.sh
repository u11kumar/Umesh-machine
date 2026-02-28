#!/usr/bin/env bash

set -e # exit on error

# ------------------------------
# User confirmation
# ------------------------------
echo "This script will install and configure applications on your Arch Linux system."
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit 1
fi

# ------------------------------
# Helper functions
# ------------------------------
install_pacman() {
  for pkg in "$@"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
      echo "Installing $pkg via pacman..."
      sudo pacman -S --noconfirm "$pkg"
    else
      echo "$pkg already installed."
    fi
  done
}

install_yay() {
  for pkg in "$@"; do
    if ! yay -Qi "$pkg" &>/dev/null; then
      echo "Installing $pkg via yay..."
      yay -S --noconfirm "$pkg"
    else
      echo "$pkg already installed."
    fi
  done
}

install_flatpak() {
  for pkg in "$@"; do
    if ! flatpak list | grep -q "$pkg"; then
      echo "Installing $pkg via flatpak..."
      flatpak install -y flathub "$pkg"
    else
      echo "$pkg already installed."
    fi
  done
}

# ------------------------------
# System update and base packages
# ------------------------------
echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing base packages..."
install_pacman zsh flatpak git base-devel

# ------------------------------
# Install yay (AUR helper)
# ------------------------------
if ! command -v yay &>/dev/null; then
  echo "Installing yay from AUR..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si --noconfirm
  cd -
  rm -rf /tmp/yay
else
  echo "yay already installed."
fi

# ------------------------------
# Install dependencies for yazi (and others)
# ------------------------------
install_pacman yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick stow
# ------------------------------
# Install applications from official repos / AUR
# ------------------------------
install_pacman gnome-text-editor helix # helix is in community, check if available
install_yay kitty onlyoffice-bin neovim vscodium nemo nemo-fileroller nemo-compare \
  nemo-preview nemo-share nemo-terminal zoxide peazip

# ------------------------------
# Install browsers (manual methods)
# ------------------------------
echo "Installing browsers..."

# Floorp, Firefox, Zen from AUR
install_yay floorp-bin firefox zen-browser-bin

# Brave via official script
if ! command -v brave-browser &>/dev/null; then
  echo "Installing Brave Browser..."
  curl -fsS https://dl.brave.com/install.sh | sh
else
  echo "Brave already installed."
fi

# ------------------------------
# Flatpak apps
# ------------------------------
echo "Ensuring Flathub remote is added..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

install_flatpak org.qbittorrent.qBittorrent \
  io.github.flattool.Warehouse \
  net.newpipe.NewPipe \
  io.github.diegopvlk.Cine \
  org.gnome.Calculator \
  org.gnome.Boxes

# ------------------------------
# Oh My Zsh and Powerlevel10k
# ------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed."
fi

# Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
else
  echo "Powerlevel10k already installed."
fi

# ------------------------------
# Zsh plugins
# ------------------------------
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Syntax highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting already installed."
fi

# Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions already installed."
fi

# History substring search
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
  echo "Installing zsh-history-substring-search..."
  git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
else
  echo "zsh-history-substring-search already installed."
fi

# ------------------------------
# Configure .zshrc
# ------------------------------
# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ] && [ ! -f "$HOME/.zshrc.bak" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.bak"
  echo "Backed up existing .zshrc to .zshrc.bak"
fi

# We'll create a new .zshrc from scratch with the desired settings.
# But if you already have a custom .zshrc in your dotfiles repo, you can symlink it later.
# For now, we'll just ensure the theme and plugins are set correctly.

cat >"$HOME/.zshrc" <<'EOF'
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme to powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    zsh-history-substring-search
    web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR=nvim
EOF

echo "New .zshrc created. You can later replace it with your own from dotfiles."

# ------------------------------
# LazyVim
# ------------------------------
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Installing LazyVim starter template..."
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
else
  echo "LazyVim config already exists at ~/.config/nvim. Skipping clone."
fi

# ------------------------------
# Optional: Symlink dotfiles
# ------------------------------
read -p "Do you want to symlink configuration files from this repo? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # Assuming the repo is cloned to ~/dotfiles
  DOTFILES_DIR="$HOME/dotfiles"
  if [ -d "$DOTFILES_DIR" ]; then
    echo "Symlinking dotfiles..."
    # Create symlinks for .zshrc and .config directories
    ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh" 2>/dev/null || true
    # .config
    for dir in "$DOTFILES_DIR/.config"/*; do
      [ -e "$dir" ] || continue
      target="$HOME/.config/$(basename "$dir")"
      ln -sfn "$dir" "$target"
    done
    echo "Symlinking done."
  else
    echo "Dotfiles directory not found at $DOTFILES_DIR. Please clone the repo first."
  fi
fi

echo "Installation complete!"
echo "You may need to restart your shell or run 'source ~/.zshrc'."
