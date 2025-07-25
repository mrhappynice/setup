The error you’re seeing means Docker can’t find the host’s `/dev/kvm` device node, which typically means either:

1. KVM isn’t installed/enabled on your host, or
2. Your user (and Docker) doesn’t have access to it.

Let’s walk through how to get `/dev/kvm` present and accessible on Pop! OS:

---

## 1. Verify your CPU supports virtualization

Open a terminal and run:

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

* If it prints `0`, your CPU either doesn’t support hardware virtualization or it’s disabled in the BIOS/UEFI.
  → Reboot, enter your BIOS/UEFI settings, and **enable “Intel VT‑x”** or **“AMD SVM”**; then recheck.
* If it prints `1` or more, you have the hardware support you need.

---

## 2. Install and start the KVM host components

```bash
sudo apt update
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```

This pulls in the KVM kernel modules and the `libvirtd` service that manages them.

Start (and optionally enable on boot) libvirt:

```bash
sudo systemctl enable --now libvirtd
```

---

## 3. Load the KVM kernel module

Usually done automatically, but you can force it:

* **Intel CPUs**

  ```bash
  sudo modprobe kvm_intel
  ```
* **AMD CPUs**

  ```bash
  sudo modprobe kvm_amd
  ```

Then confirm the device node exists:

```bash
ls -l /dev/kvm
# should show something like: crw-rw---- 1 root kvm 10, 232 Jul 25 12:34 /dev/kvm
```

---

## 4. Add yourself (and Docker) to the `kvm` group

If `/dev/kvm` is owned by group `kvm`, make sure your user is in that group so Docker can access it:

```bash
sudo usermod -aG kvm $USER
```

Log out and back in (or reboot) so the group change takes effect.

---

## 5. Run your container with the device exposed

Now that `/dev/kvm` exists and is accessible, launch your container with:

```bash
docker run --device /dev/kvm … your-image
```

(or add `--privileged` if you need broader access, though `--device /dev/kvm` is more minimal.)

---

### Quick checklist

1. **Hardware support**: `egrep -c '(vmx|svm)' /proc/cpuinfo` > 0
2. **KVM packages installed**: `qemu-kvm`, `libvirt-daemon-system`, `libvirt-clients`
3. **Service running**: `systemctl status libvirtd`
4. **Module loaded**: `lsmod | grep kvm`
5. **Device exists**: `ls -l /dev/kvm`
6. **User in kvm group**: `groups $USER` includes `kvm`
7. **Docker command** includes `--device /dev/kvm`

After that, Docker should be able to see `/dev/kvm` and let your container use hardware virtualization. !

# Install Docker

Because you installed **Docker Desktop for Linux**, you don’t actually have the “real” Docker Engine system service running on your Pop!\_OS host. Docker Desktop runs inside its own embedded VM and exposes only that VM’s devices — so even though `/dev/kvm` exists on your host, the Desktop VM has no idea about it.

---

## Two ways to fix this

### 1) Install & run the native Docker Engine

This is the easiest way to get a “rootful” Docker daemon on your Pop!\_OS host that can see `/dev/kvm`.

```bash
# (Optional) Remove Docker Desktop if you don’t need its GUI:
sudo apt remove docker-desktop

# Add Docker’s official APT repo and install:
sudo apt update
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) \
       signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Enable and start the system Docker service:
sudo systemctl enable --now docker

# Verify:
sudo systemctl status docker
docker context use default   # make sure you’re on the host’s daemon
docker compose up -d         # now /dev/kvm will be visible
```

Once you’re using the **system** Docker Engine, your `devices: - "/dev/kvm:/dev/kvm"` mount will work straight away.

---

### 2) Keep DockerDesktop but use passthrough (not recommended)

Docker Desktop for Linux doesn’t officially support passing `/dev/kvm` through to its VM. In theory you could try:

```yaml
# in docker-compose.yml
services:
  windows:
    privileged: true
    devices:
      - "/dev/kvm:/dev/kvm"
```

…but in practice the Desktop VM simply won’t forward that host device. You’d have to switch to a hypervisor that supports nested‑VT passthrough (and configure it by hand), which defeats the point of using Docker Desktop.

