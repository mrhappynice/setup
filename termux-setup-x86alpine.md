Emulating an x86 Linux distribution without a graphical user interface (GUI) on your Android device using Termux and QEMU is achievable. A suitable option is **Alpine Linux**, known for its minimal footprint and efficiency. Here's how to set up and run Alpine Linux without a GUI:

**1. Update Termux Packages:**

Ensure your Termux environment is up-to-date:

```bash
pkg update -y && pkg upgrade -y
```

**2. Install Required Packages:**

Install `wget` for downloading files and QEMU for x86_64 emulation:

```bash
pkg install wget qemu-system-x86_64-headless qemu-utils -y
```

**3. Set Up Directory Structure:**

Create a directory for Alpine Linux and navigate into it:

```bash
mkdir -p ~/alpine-linux && cd ~/alpine-linux
```

**4. Download Alpine Linux ISO:**

Download the latest Alpine Linux virtual ISO image suitable for x86_64 architecture:

```bash
wget https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64/alpine-virt-3.21.0-x86_64.iso -O alpine.iso
```
Check current version numbers and change

**5. Create a Virtual Disk Image:**

Create a 500MB virtual disk image in QCOW2 format for the Alpine installation:

```bash
qemu-img create -f qcow2 alpine.qcow2 500M
```

**6. Install Alpine Linux:**

Start the QEMU virtual machine to boot from the Alpine ISO and install the system:

```bash
qemu-system-x86_64 -smp 1 -m 512 \
  -drive file=alpine.qcow2,if=virtio,format=qcow2 \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 \
  -device virtio-net,netdev=n1 \
  -cdrom alpine.iso -boot d \
  -nographic
```

This command allocates 1 CPU core and 512MB of RAM to the virtual machine, sets up a virtual hard drive, configures network forwarding (mapping host port 2222 to guest port 22 for SSH access), and boots from the Alpine ISO in a non-graphical mode.

**7. Configure Alpine Linux:**

Within the QEMU environment, log in as the root user (no password required) and initiate the setup:

```bash
setup-alpine
```

Follow the on-screen prompts to configure your system. When prompted for the disk to use, select `vda`, and choose `sys` mode for a full disk installation. Confirm the disk erasure when prompted.

**8. Finalize Installation:**

After completing the setup, shut down the virtual machine:

```bash
poweroff
```

**9. Boot into the Installed System:**

Start the virtual machine from the installed disk image:

```bash
qemu-system-x86_64 -smp 1 -m 512 \
  -drive file=alpine.qcow2,if=virtio,format=qcow2 \
  -netdev user,id=n1,hostfwd=tcp::2222-:22 \
  -device virtio-net,netdev=n1 \
  -nographic
```

**10. Accessing the Alpine System via SSH:**

To interact with the Alpine system more conveniently, especially since it's running in non-graphical mode, you can use SSH. From another terminal on your Android device or a computer on the same network, connect using:

```bash
ssh root@127.0.0.1 -p 2222
```

This command connects to the root user of the Alpine system via the forwarded port.

**Important Considerations:**

- **Performance:** Emulating an x86 system on an ARM-based Android device may result in reduced performance.

- **Resource Allocation:** Adjust CPU (`-smp`) and memory (`-m`) allocations based on your device's capabilities.

- **Data Persistence:** The virtual disk image (`alpine.qcow2`) retains data between sessions. Ensure sufficient storage space on your device.

