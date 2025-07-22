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

The devbox will automatically generate an SSH key on first run. To enable GitHub access:

1. SSH into your devbox and get the public key:
   ```bash
   cat /data/.ssh/id_ed25519.pub
   ```

2. Add this key to GitHub:
   - For repository-specific access: Go to the repository → Settings → Deploy keys → Add deploy key
   - For full account access: Go to GitHub → Settings → SSH and GPG keys → New SSH key

3. Test the connection:
   ```bash
   ssh -T git@github.com
   ```

## Notes

- Development projects can be cloned into `/data` for persistence
- The `/data` directory persists across container restarts
- Default user: `dev` (with sudo access)