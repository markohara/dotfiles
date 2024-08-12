#!/bin/bash

items=(
    ".config/alacritty"
    ".config/skhd"
    ".config/yabai"
    ".config/bat"
    ".gitconfig"
    ".p10k.zsh"
    ".zshrc"
)

echo "This script will remove the specified dotfiles and folders from your home directory."
echo "Please make sure you have backups if needed."
read -p "Do you want to proceed? (y/N): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
    for item in "${items[@]}"; do
        local item="$HOME/$1"
        rm -rf "$item"
    done
    echo "Cleanup completed."
else
    echo "Operation cancelled."
fi