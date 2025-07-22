# My Fly.io DevBox

A persistent development environment on Fly.io with SSH and Mosh access.

## Features

- Ubuntu 22.04 base image
- SSH and Mosh server support
- Development tools (git, vim, curl, wget, build-essential)
- Persistent data volume mounted at `/data`
- Accessible from iOS devices via SSH/Mosh clients

## Quick Start

1. Deploy to Fly.io:
   ```bash
   flyctl launch
   flyctl deploy
   ```

2. Create persistent volume:
   ```bash
   flyctl volumes create devbox_data --region <your-region> --size 10
   ```

3. Connect via SSH:
   ```bash
   ssh dev@my-fly-devbox.fly.dev -p 2222
   ```

4. Connect via Mosh:
   ```bash
   mosh dev@my-fly-devbox.fly.dev --ssh="ssh -p 2222"
   ```

## Security

Remember to:
- Change the default password
- Set up SSH key authentication
- Disable password authentication once keys are configured

## GitHub Access

For security, generate the SSH key locally and copy only the public key to the devbox:

### Automated Setup (Recommended)

Run the setup script from your local machine:
```bash
chmod +x setup-github-key.sh
./setup-github-key.sh
```

### Manual Setup

1. Generate a key locally:
   ```bash
   ssh-keygen -t ed25519 -C "devbox@aeonia.ai" -f ~/.ssh/id_ed25519_devbox
   ```

2. Copy keys to devbox:
   ```bash
   scp -P 2222 ~/.ssh/id_ed25519_devbox* dev@HOST:/data/.ssh/
   ssh dev@HOST -p 2222 'cd /data/.ssh && mv id_ed25519_devbox id_ed25519_github'
   ```

3. Add the public key to GitHub:
   - Go to [GitHub SSH Keys](https://github.com/settings/keys)
   - Click "New SSH key"
   - Paste the contents of `~/.ssh/id_ed25519_devbox.pub`

4. Test the connection from devbox:
   ```bash
   ssh -T git@github.com
   ```

## Notes

- Development projects can be cloned into `/data` for persistence
- The `/data` directory persists across container restarts
- Default user: `dev` (with sudo access)