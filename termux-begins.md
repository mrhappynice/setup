Setup Termux:

1. **Update and Upgrade**:
   - Open Termux and update package lists:
     ```bash
     pkg update -y && pkg upgrade -y
     ```
2. **Install wget**:
     ```bash
     pkg install git
     ```
3. **Download setup files:**
   ```bash
   git clone https://github.com/mrhappynice/setup.git
   ```
4. **Run SSH setup:**
   - set password, get ip address to connect remotely:
     ```bash
     chmod +x termux_setup_ssh.sh
     ./termux_setup_ssh.sh
     ```
   - get username:
     ```bash
     whoami
     ```


