#!/bin/bash
# Setup script for persistent development environment

echo "🚀 Setting up persistent development environment..."

# Ensure we're in the dev home directory
cd /home/dev

# Set up persistent storage directories
echo "📁 Setting up persistent storage directories..."
mkdir -p /data/{projects,tools,.config,.cache,.local,.ssh}

# Move existing configs to persistent storage if they exist
if [ ! -L "$HOME/.config" ]; then
    if [ -d "$HOME/.config" ]; then
        cp -r "$HOME/.config/"* /data/.config/ 2>/dev/null || true
    fi
    rm -rf "$HOME/.config"
    ln -sf /data/.config "$HOME/.config"
fi

if [ ! -L "$HOME/.cache" ]; then
    rm -rf "$HOME/.cache"
    ln -sf /data/.cache "$HOME/.cache"
fi

if [ ! -L "$HOME/.local" ]; then
    if [ -d "$HOME/.local" ]; then
        cp -r "$HOME/.local/"* /data/.local/ 2>/dev/null || true
    fi
    rm -rf "$HOME/.local"
    ln -sf /data/.local "$HOME/.local"
fi

# Set up SSH keys in persistent storage
if [ ! -L "$HOME/.ssh" ]; then
    if [ -d "$HOME/.ssh" ]; then
        cp -r "$HOME/.ssh/"* /data/.ssh/ 2>/dev/null || true
    fi
    rm -rf "$HOME/.ssh"
    ln -sf /data/.ssh "$HOME/.ssh"
fi

# Ensure proper permissions
chmod 700 /data/.ssh
chmod 600 /data/.ssh/authorized_keys 2>/dev/null || true

# Install Claude CLI if not already installed
if [ ! -f "/data/tools/claude" ]; then
    echo "🤖 Installing Claude CLI..."
    cd /data/tools
    CLAUDE_URL=$(curl -s https://api.github.com/repos/anthropics/claude-code/releases/latest | jq -r '.assets[] | select(.name | contains("linux-x64")) | .browser_download_url')
    if [ ! -z "$CLAUDE_URL" ]; then
        curl -LsSf "$CLAUDE_URL" | tar -xz
        sudo ln -sf /data/tools/claude /usr/local/bin/claude 2>/dev/null || true
    fi
fi

# Clone Gaia project if not already present
if [ ! -d "/data/projects/gaia" ]; then
    echo "📥 Cloning Gaia project..."
    cd /data/projects
    git clone https://github.com/Aeonia-ai/gaia.git
    echo "✅ Gaia project cloned successfully"
else
    echo "✅ Gaia project already exists"
fi

# Set up Git configuration
git config --global user.name "Jason Asbahr"
git config --global user.email "ops@aeonia.ai"

# Check for GitHub SSH key
if [ ! -f "/data/.ssh/id_ed25519_github" ]; then
    echo ""
    echo "⚠️  No GitHub SSH key found in /data/.ssh/id_ed25519_github"
    echo ""
    echo "To set up GitHub access, generate a key locally and copy it:"
    echo "1. On your local machine:"
    echo "   ssh-keygen -t ed25519 -C 'devbox@aeonia.ai' -f ~/.ssh/id_ed25519_devbox"
    echo ""
    echo "2. Copy the key to this devbox:"
    echo "   scp -P 2222 ~/.ssh/id_ed25519_devbox* dev@HOST:/data/.ssh/"
    echo "   ssh dev@HOST -p 2222 'mv /data/.ssh/id_ed25519_devbox /data/.ssh/id_ed25519_github'"
    echo ""
    echo "3. Add the public key to GitHub (Settings → SSH keys)"
    echo ""
else
    echo "✅ GitHub SSH key found at /data/.ssh/id_ed25519_github"
fi

# Set up SSH config for GitHub
if [ ! -f "/data/.ssh/config" ]; then
    cat > /data/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile /data/.ssh/id_ed25519_github
    IdentitiesOnly yes
    StrictHostKeyChecking accept-new
EOF
    chmod 600 /data/.ssh/config
fi

# Create a persistent bashrc additions file
if [ ! -f "/data/.bashrc_additions" ]; then
    cat > /data/.bashrc_additions << 'EOL'
# Persistent bashrc additions
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Docker aliases
alias dc='docker compose'
alias dps='docker ps'
alias dlog='docker logs -f'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'

# Project shortcuts
alias cdg='cd /data/projects/gaia'
alias cdd='cd /data'

# Python aliases
alias py='python3.11'
alias pip='python3.11 -m pip'

# Source UV environment if available
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# SSH Agent setup
if [ -f /data/.ssh/id_ed25519_github ]; then
    eval "$(ssh-agent -s)" > /dev/null 2>&1
    ssh-add /data/.ssh/id_ed25519_github > /dev/null 2>&1
fi
EOL
fi

# Add to bashrc if not already there
if ! grep -q "source /data/.bashrc_additions" ~/.bashrc; then
    echo "source /data/.bashrc_additions" >> ~/.bashrc
fi

# Verify environment setup
echo ""
echo "🔍 Verifying environment..."
echo "Python: $(python3.11 --version 2>/dev/null || echo 'Not installed')"
echo "Node: $(node --version 2>/dev/null || echo 'Not installed')"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"
echo "UV: $(which uv 2>/dev/null || echo 'Not installed')"
echo "Claude CLI: $(which claude 2>/dev/null || echo 'Not installed')"

echo ""
echo "✅ Persistent development environment setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Copy .env file: scp .env dev@HOST:/data/projects/gaia/.env"
echo "2. cd /data/projects/gaia"
echo "3. docker compose up"
echo ""
echo "🔧 Useful aliases added:"
echo "  cdg - cd to Gaia project"
echo "  cdd - cd to /data"
echo "  dc  - docker compose"
echo "  py  - python3.11"
echo ""
echo "All configuration and projects are stored in /data/ and will persist across container restarts."