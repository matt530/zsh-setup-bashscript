#!/bin/bash

# Exit on any error
set -e

echo "🔧 Setting up Zsh with plugins on macOS..."

# Install Homebrew if not installed
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Zsh if not installed
if ! command -v zsh >/dev/null 2>&1; then
  echo "🐚 Installing Zsh..."
  brew install zsh
fi

# Set Zsh as default shell
if [[ "$SHELL" != *zsh ]]; then
  echo "⚙️ Setting Zsh as the default shell..."
  chsh -s /bin/zsh
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "🔌 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "🔌 Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🔌 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Update ~/.zshrc plugins list and theme
echo "⚙️ Updating .zshrc..."

ZSHRC="$HOME/.zshrc"
PLUGINS_LINE=$(grep "^plugins=" "$ZSHRC" || true)

# Update plugins line if not present or modify the existing one
if [[ -z "$PLUGINS_LINE" ]]; then
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
else
  # Replace line with updated plugin list
  sed -i.bak 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"
fi

# Set Powerlevel10k as the theme
sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k/powerlevel10k"/' "$ZSHRC"

echo "✅ Done! Restart your terminal or run: source ~/.zshrc"

