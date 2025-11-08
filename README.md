# My Dotfiles

Personal configuration files for macOS

## Contents

- **sketchybar/** - Custom menu bar with AeroSpace integration
- **aerospace/** - AeroSpace window manager configuration

## Installation

# Sketchybar
ln -sf ~/dotfiles/sketchybar ~/.config/sketchybar

# AeroSpace
ln -sf ~/dotfiles/aerospace ~/.config/aerospaceEOF

# Create .gitignore
cat > .gitignore << 'EOF'
.DS_Store
*.swp
*.log
