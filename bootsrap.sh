#!/bin/bash
# bootstrap.sh - set up dotfiles using stow

cd "$(dirname "$0")" # go to dotfiles directory

# Check if stow is installed
if ! command -v stow &>/dev/null; then
  echo "GNU Stow is not installed. Please install it first."
  echo "On Arch: sudo pacman -S stow"
  echo "On Debian: sudo apt install stow"
  exit 1
fi

# Stow with --no-folding to avoid replacing entire directories
stow --no-folding -t "$HOME" .

echo "Dotfiles linked successfully!"
