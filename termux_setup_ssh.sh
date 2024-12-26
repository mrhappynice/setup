#!/bin/bash

# Update and upgrade packages -- 
# pkg update -y && pkg upgrade -y

# Install OpenSSH
pkg install -y openssh

# Set a password for SSH access
echo "Please enter a password for SSH access:"
passwd

# Create the ssh directory and sshd_config file if they don't exist
mkdir -p $PREFIX/etc/ssh
CONFIG_FILE="$PREFIX/etc/ssh/sshd_config"
if [ ! -f "$CONFIG_FILE" ]; then
    touch "$CONFIG_FILE"
fi

# Configure SSH to use a non-privileged port (8022)
if grep -q "^Port " "$CONFIG_FILE"; then
    sed -i "s/^Port .*/Port 8022/" "$CONFIG_FILE"
else
    echo "Port 8022" >> "$CONFIG_FILE"
fi

# Start the SSH daemon
sshd

# Display the device's IP address
echo "Your device's IP addresses are:"
ip a | grep 'inet ' | awk '{print $2}'
echo "You can connect via SSH using: ssh -p 8022 username@device_ip"

