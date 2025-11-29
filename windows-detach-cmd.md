
✅ `Start-Process` is detaching the *child* process
❌ but **your app is waiting for *PowerShell itself* to exit**, and in your environment it never finishes cleanly.

So the fix is:

# ✅ **Launch PowerShell itself in a detached background process**

We’ll use **`cmd /c start`** to launch PowerShell *itself* detached — and since your app hates quotes, we’ll keep it **quote-free**.

---

# ⭐ Try this (should finally detach cleanly)

```cmd
cmd /c start powershell -NoLogo -NoProfile -Command Start-Process bplus-searchrs\bplus-searchrs.exe -WorkingDirectory bplus-searchrs -RedirectStandardOutput C:\Temp\bplus-searchrs.log -RedirectStandardError C:\Temp\bplus-searchrs.log -WindowStyle Hidden
```

### Why this works

* `cmd /c start` → launches a **new detached process** (Windows-native).
* That new process runs PowerShell.
* PowerShell calls `Start-Process` (which detaches the EXE).
* Both PowerShell and the new `cmd` instance exit immediately.
* Your app gets control back instantly — *just like the Linux `nohup (…) &`*.

### Notes

* No inner quotes ✔️
* No directory persistence required ✔️
* Background process stays alive ✔️
* Your app doesn't hang ✔️

---



Since your process is:

```
bplus-searchrs.exe
```

running under its own working directory, we can cleanly stop it in a few different ways depending on how safe you want to be.

---

# 🛑 **1. Clean shutdown (preferred): `Stop-Process`**

This stops only **your** process and nothing else. No quotes, so it works in your environment:

```cmd
powershell -Command Stop-Process -Name bplus-searchrs -Force
```

### What it does:

* Finds any running `bplus-searchrs.exe`
* Stops it cleanly
* Uses `-Force` so it won’t hang on confirmation

---

# 🛑 **2. Kill by EXE path (if multiple copies could run)**

If you might have multiple processes with the same name, this kills only the ones in your `bplus-searchrs` folder:

```cmd
powershell -Command Get-Process bplus-searchrs | Where-Object { $_.Path -like "*bplus-searchrs*" } | Stop-Process -Force
```

Still **no quotes** anywhere.

---

# 🛑 **3. CMD-only version (not as clean, but works)**

```cmd
taskkill /IM bplus-searchrs.exe /F
```

This is brute-force but simple.

---

# ⭐ Recommended shutdown command (cleanest)

Use this one unless you have multiple copies running:

```cmd
powershell -Command Stop-Process -Name bplus-searchrs -Force
```

---


