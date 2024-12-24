
set custom resolution:

Defining a custom resolution in XFCE involves using the **xrandr** tool to set the desired resolution. Here’s a step-by-step guide:

---

### Step 1: Identify your display name
1. Open a terminal.
2. Run the following command:
   ```bash
   xrandr
   ```
   Look for the name of your display (e.g., `HDMI-1`, `DP-1`, `eDP-1`, etc.).

---

### Step 2: Calculate the modeline
1. Use the `cvt` command to generate a modeline for your desired resolution. For example, to create a 1920x1080 resolution:
   ```bash
   cvt 1920 1080
   ```
2. The output will look something like this:
   ```
   # 1920x1080 60.00 Hz (CVT) hsync: 67.50 kHz; pclk: 173.00 MHz
   Modeline "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
   ```

---

### Step 3: Add the new resolution
1. Copy the `Modeline` part (e.g., `"1920x1080_60.00"` and its parameters).
2. Add the new mode with the following command:
   ```bash
   xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
   ```
3. Associate this mode with your display. For example, if your display is `HDMI-1`:
   ```bash
   xrandr --addmode HDMI-1 "1920x1080_60.00"
   ```

---

### Step 4: Apply the resolution
1. Set the resolution using the following command:
   ```bash
   xrandr --output HDMI-1 --mode "1920x1080_60.00"
   ```

---

### Step 5: Make it persistent
The above commands only apply for the current session. To make them persistent across reboots, you need to add the commands to your startup configuration.

1. Create or edit a startup script:
   ```bash
   nano ~/.xprofile
   ```
2. Add the following lines:
   ```bash
   xrandr --newmode "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
   xrandr --addmode HDMI-1 "1920x1080_60.00"
   xrandr --output HDMI-1 --mode "1920x1080_60.00"
   ```
3. Save the file and exit.

---

### Step 6: Reboot and test
Reboot your system, and the custom resolution should be applied automatically.
