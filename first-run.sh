#!/bin/bash
# First run setup script - runs inside container on first boot

# Check if this is the first run
if [ ! -f "/data/.first_run_complete" ]; then
    echo "🎉 First run detected! Setting up persistent environment..."
    
    # Run the persistent environment setup
    su - dev -c "/home/dev/setup-persistent-env.sh"
    
    # Mark first run as complete
    touch /data/.first_run_complete
    echo "✅ First run setup complete"
else
    echo "✅ Environment already set up"
fi

# Ensure persistent links are in place
su - dev -c "source /home/dev/.setup_persistent.sh"