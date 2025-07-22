#!/bin/bash
# Development Environment Setup Script for Gaia Project

echo "🚀 Setting up development environment for Gaia project..."

# Update package list
echo "📦 Updating package list..."
sudo apt-get update -y

# Install Python 3.11 and development tools
echo "🐍 Installing Python 3.11 and development tools..."
sudo apt-get install -y \
  python3.11 \
  python3.11-venv \
  python3-pip \
  python3.11-dev \
  build-essential \
  postgresql-client \
  redis-tools \
  git \
  curl \
  wget \
  jq \
  ripgrep \
  fd-find \
  bat \
  tmux \
  htop \
  tree \
  neovim \
  ca-certificates \
  gnupg \
  lsb-release

# Install Docker
echo "🐳 Installing Docker..."
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Update and install Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Install Node.js 18+
echo "📦 Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install global npm packages
echo "📦 Installing npm packages..."
sudo npm install -g yarn pnpm

# Install UV (modern Python package manager)
echo "🚀 Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# Install pipx
echo "📦 Installing pipx..."
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Update PATH in bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Create project structure in persistent storage
echo "📁 Creating project directories..."
mkdir -p /data/projects
mkdir -p /data/tools
mkdir -p /data/.config
mkdir -p /data/.cache

# Link config directories to persistent storage
ln -sf /data/.config ~/.config
ln -sf /data/.cache ~/.cache

# Install Claude CLI
echo "🤖 Installing Claude CLI..."
cd /data/tools
# Get the latest version URL from GitHub releases
CLAUDE_URL=$(curl -s https://api.github.com/repos/anthropics/claude-code/releases/latest | jq -r '.assets[] | select(.name | contains("linux-x64")) | .browser_download_url')
if [ ! -z "$CLAUDE_URL" ]; then
    curl -LsSf "$CLAUDE_URL" | tar -xz
    sudo ln -sf /data/tools/claude /usr/local/bin/claude
else
    echo "⚠️  Could not find Claude CLI download URL"
fi

# Clone Gaia project
echo "📥 Cloning Gaia project..."
cd /data/projects
if [ ! -d "gaia" ]; then
    git clone https://github.com/JasonAsbahr/gaia.git
fi

# Set up Git configuration
echo "🔧 Setting up Git configuration..."
git config --global user.name "Jason Asbahr"
git config --global user.email "ops@aeonia.ai"

echo "✅ Development environment setup complete!"
echo ""
echo "Next steps:"
echo "1. Log out and back in for Docker group changes to take effect"
echo "2. Copy .env file: scp local/path/.env dev@HOST:/data/projects/gaia/"
echo "3. cd /data/projects/gaia && docker compose up"
echo ""
echo "Persistent data is stored in /data/"