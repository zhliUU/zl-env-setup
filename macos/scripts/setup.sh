#!/bin/bash

echo "🔧 Setting up development environment..."

# 1. Install Homebrew if it's not installed
if ! command -v brew &> /dev/null; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi

# 2. Install packages from Brewfile
if [ -f "../Brewfile" ]; then
  echo "📚 Installing packages from Brewfile..."
  brew bundle --file=../Brewfile
fi

# 3. Setup SSH directory and permissions
echo "🔐 Setting up SSH config..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 4. Add SSH config block for GitHub only if it doesn't exist
if grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
  echo "⚠️ SSH config for github.com already exists — skipping..."
else
  cat <<EOF >> ~/.ssh/config
# GitHub
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519
  AddKeysToAgent yes
  UseKeychain yes

EOF
  chmod 600 ~/.ssh/config
  echo "✅ SSH config for github.com added to ~/.ssh/config"
fi

# 5. Add SSH key to agent + keychain (if key exists)
if [ -f ~/.ssh/id_ed25519 ]; then
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  echo "🔑 SSH key added to agent"
else
  echo "⚠️ No SSH key found at ~/.ssh/id_ed25519 — generate one if needed."
fi

# 6. Ask to set global Git identity (optional)
read -p "🌍 Do you want to set a global Git user/email? (y/n): " SET_GLOBAL
if [[ "$SET_GLOBAL" == "y" || "$SET_GLOBAL" == "Y" ]]; then
  read -p "Enter global Git user name: " GLOBAL_NAME
  read -p "Enter global Git email: " GLOBAL_EMAIL
  git config --global user.name "$GLOBAL_NAME"
  git config --global user.email "$GLOBAL_EMAIL"
  echo "✅ Global Git config set."
else
  echo "⏭️ Skipping global Git config."
fi

# 7. Ask to set local Git identity (optional)
read -p "📁 Do you want to set a local Git user/email for this project? (y/n): " SET_LOCAL
if [[ "$SET_LOCAL" == "y" || "$SET_LOCAL" == "Y" ]]; then
  read -p "Enter local Git user name: " LOCAL_NAME
  read -p "Enter local Git email: " LOCAL_EMAIL
  git config user.name "$LOCAL_NAME"
  git config user.email "$LOCAL_EMAIL"
  echo "✅ Local Git config set for this project."
else
  echo "⏭️ Skipping local Git config."
fi

echo "🎉 Setup complete!"