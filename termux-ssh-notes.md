To automate the setup of an SSH server in Termux, including creating the `sshd_config` file with the appropriate port configuration, you can use the following Bash script:

```bash
#!/bin/bash

# Update and upgrade packages
pkg update -y && pkg upgrade -y

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
```

**Instructions to Download and Execute the Script:**

1. **Save the Script Online**:
   - Upload the script to a web server or a code hosting platform like GitHub. Ensure it's accessible via a direct URL, such as `https://example.com/setup-ssh-termux.sh`.

2. **Download and Execute the Script in Termux**:
   - Open Termux on your Android device.
   - Use `curl` to download and execute the script:
     ```bash
     curl -sSL https://example.com/setup-ssh-termux.sh | bash
     ```
   - This command fetches the script from the specified URL and pipes it directly to `bash` for execution. The `-sSL` flags ensure the download is silent and follows any redirects.

**Security Consideration**: Executing scripts directly from a URL can be risky if the source is untrusted. It's advisable to review the script's content before execution to ensure it doesn't contain malicious code. You can download the script first, inspect it, and then run it:

```bash
curl -O https://example.com/setup-ssh-termux.sh
less setup-ssh-termux.sh  # Review the script
bash setup-ssh-termux.sh
```

By following these steps, you'll automate the SSH server setup on your Android device using Termux. Remember to replace `https://example.com/setup-ssh-termux.sh` with the actual URL where your script is hosted.

For more detailed information, you can refer to the Termux Wiki on Remote Access.  
