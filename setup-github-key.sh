#!/bin/bash
# Helper script to set up GitHub SSH key for devbox

echo "🔑 Setting up GitHub SSH key for devbox..."

# Generate key if it doesn't exist
KEY_PATH="$HOME/.ssh/id_ed25519_devbox"
if [ ! -f "$KEY_PATH" ]; then
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "devbox@aeonia.ai" -f "$KEY_PATH" -N ""
else
    echo "Using existing key at $KEY_PATH"
fi

# Get devbox host
read -p "Enter devbox hostname or IP (e.g., 169.155.62.160): " DEVBOX_HOST

echo ""
echo "📋 Copying keys to devbox..."
scp -P 2222 -i ~/.ssh/id_ed25519_ops "$KEY_PATH" "$KEY_PATH.pub" dev@$DEVBOX_HOST:/data/.ssh/

echo "🔧 Setting up key on devbox..."
ssh dev@$DEVBOX_HOST -p 2222 -i ~/.ssh/id_ed25519_ops << 'EOF'
cd /data/.ssh
mv id_ed25519_devbox id_ed25519_github
mv id_ed25519_devbox.pub id_ed25519_github.pub
chmod 600 id_ed25519_github
chmod 644 id_ed25519_github.pub
echo "✅ Keys installed on devbox"
EOF

echo ""
echo "📋 Add this public key to GitHub:"
echo "────────────────────────────────────────────────────────────────"
cat "$KEY_PATH.pub"
echo "────────────────────────────────────────────────────────────────"
echo ""
echo "Go to: https://github.com/settings/keys"
echo "Click 'New SSH key' and paste the above key"
echo ""
echo "✅ Setup complete!"