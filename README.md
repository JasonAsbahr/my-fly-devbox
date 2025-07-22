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

## Notes

- Development projects can be cloned into `/data` for persistence
- The `/data` directory persists across container restarts
- Default user: `dev` (with sudo access)