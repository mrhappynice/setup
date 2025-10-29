

---

### 🧩 Browser backends on Linux

* **Chrome / Chromium / Edge:**
  Chrome uses **Dawn** as its WebGPU implementation. On Linux, Dawn *can* use the Vulkan backend — **but it’s not always enabled by default**.

  * If your GPU driver or Vulkan loader is missing certain features (or Chrome detects instability), it silently falls back to a null backend and WebGPU will appear “unsupported”.
  * AMD GPUs on Mesa (RADV driver) are generally supported, but sometimes Chrome’s Vulkan path is disabled due to past driver bugs.
  * You can check backend info at `chrome://gpu` → search for “WebGPU backend”.

    * If it says `Vulkan`, you’re good.
    * If it says “disabled” or “Software only,” Chrome didn’t bring up Vulkan.

* **Firefox:**
  Firefox’s WebGPU uses the **wgpu** library, which *does* support Vulkan on Linux, but:

  * It’s behind a flag. You must enable it manually:

    1. Go to `about:config`
    2. Set `dom.webgpu.enabled` → `true`
    3. (Optionally) also set `gfx.webrender.all` → `true`
  * After restarting Firefox, you can test WebGPU support at [https://webgpu.github.io/webgpu-samples/](https://webgpu.github.io/webgpu-samples/).
    If it still fails, run Firefox from the terminal with:

    ```bash
    MOZ_LOG="WebGPU:5" firefox
    ```

    to see detailed backend info (you should see it trying to initialize `wgpu_core::backend::vulkan`).

---

### ⚙️ Driver considerations

Pop!_OS ships Mesa drivers. Make sure yours are up to date:

```bash
sudo apt update && sudo apt upgrade mesa-vulkan-drivers mesa-utils
```

Then verify Vulkan works:

```bash
vulkaninfo | less
```

If that fails or shows no devices, WebGPU won’t work until Vulkan is fixed at the driver level.

---

### ✅ Recommended test flow

1. **Confirm Vulkan:**
   `vulkaninfo | grep "VK_VERSION"`
   You should see `Vulkan Instance Version: 1.3.xxx` (or 1.2+).
2. **Confirm WebGPU backend:**

   * Chrome → `chrome://gpu`
   * Firefox → test a WebGPU sample with logging enabled.
3. **If Chrome still fails:**
   Try launching Chrome with an experimental flag:

   ```bash
   google-chrome --enable-unsafe-webgpu --enable-features=Vulkan
   ```

   Then recheck at `chrome://gpu`.

---
