It isn’t that LM Studio or llama.cpp don’t “see” your RX 6600 — it’s that you haven’t got a working Vulkan user-space driver stack installed (the kernel driver is in place, but there’s no ICD for Vulkan to hook into). On openSUSE Tumbleweed you get Vulkan support for AMD GPUs via either:

1. **RADV** (the Mesa-3D Vulkan driver, default in Tumbleweed)
2. **AMDVLK** (AMD’s official open-source Vulkan driver)

You need at least one of those installed (and the matching 32-bit libraries if your application is 32-bit), plus the Vulkan tooling to verify it:

---

### 1. Install the Mesa/RADV Vulkan stack

```bash
sudo zypper in \
  vulkan-tools \
  libvulkan_radeon \
  libvulkan_radeon-32bit \
  libvulkan1 \
  libvulkan1-32bit \
  libdrm_amdgpu1 \
  libdrm_amdgpu1-32bit
```

* **`vulkan-tools`** gives you the `vulkaninfo` utility to check your setup.
* **`libvulkan_radeon`** (and its `-32bit` variant if needed) is the RADV driver itself.
* **`libvulkan1`** provides the core Vulkan loader.
* **`libdrm_amdgpu1`** lets Mesa talk to the kernel.
  ([openSUSE Wiki][1])

Once installed, run:

```bash
vulkaninfo | less
```

You should see your RX 6600 listed under **“VkPhysicalDeviceProperties”**. If you still get “No ICD found” or “failed to load…” errors, double-check that files like `/etc/vulkan/icd.d/radeon_icd.x86_64.json` exist.

---

### 2. (Optional) Install AMDVLK instead

If you want AMD’s own driver, add AMD’s repo and install `amdvlk`:

```bash
# Add AMD’s Vulkan repo (if you haven’t)
sudo zypper ar -f https://repo.radeon.com/amdgpu/latest/opensuse/tumbleweed/ amdgpu
sudo zypper ref

# Install AMD’s Vulkan driver
sudo zypper in amdvlk amdvlk-32bit
```

That will drop an `/etc/vulkan/icd.d/amd_icd64.json` pointing at AMD’s driver. You can have both RADV and AMDVLK installed side by side — the loader will pick one or let you override with `VK_ICD_FILENAMES`.

---

### 3. Verify Vulkan access

1. **Check groups**
   Make sure your user is in the `video` (and on some distros `render`) group so you can open `/dev/dri/renderD128`.

   ```bash
   groups
   sudo usermod -aG video,render $(whoami)
   # then log out and back in
   ```
2. **Run a quick Vulkan test**

   ```bash
   vulkaninfo | grep "deviceName"
   ```

   You should see something like “AMD Radeon RX 6600”.

---

### 4. Tell llama.cpp which GPU

If you have multiple devices or the default isn’t picked up, run LM Studio / llama.cpp with:

```bash
./main --vulkan --vulkan-device 0    # or the index from vulkaninfo
```

---

#### Why this happens

* Tumbleweed’s kernel (amdgpu) is just the kernel driver.
* **Vulkan** is a user-space API; you need an **ICD** (Installable Client Driver) in `/etc/vulkan/icd.d/`.
* Without the ICD JSON files from Mesa (RADV) or AMDVLK, `vulkaninfo` and any Vulkan-based application (like llama.cpp’s Vulkan backend) will report “no GPU found.”

Once you’ve got the ICD in place and verified with `vulkaninfo`, LM Studio’s Vulkan backend will see your RX 6600 immediately.

[1]: https://en.opensuse.org/Vulkan?utm_source=chatgpt.com "Vulkan - openSUSE Wiki"
