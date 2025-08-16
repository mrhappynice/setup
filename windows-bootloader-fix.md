GRUB’s EFI entry is still the one your firmware is trying to run, and Windows Boot Manager isn’t set up or isn’t registered in the UEFI firmware’s boot list.

You can fix this without reinstalling Windows by **rebuilding the Windows Boot Manager** on the EFI partition and telling your UEFI to use it.

---

## **Safe fix: Reinstall Windows Boot Manager to EFI partition**

### 1. Boot into any working Windows install

Since you can’t boot directly, pick **Windows 10 or 11** from your BIOS boot menu.

---

### 2. Find the EFI System Partition

1. Press **Win + X** → choose **Disk Management**.
2. Look for the small **100–300 MB EFI System Partition** (it will say “EFI System” under “File System”).
3. Note which disk and partition it is on.
   Windows sometimes has one EFI partition shared by all Windows installs — we’ll use that.

---

### 3. Assign a temporary drive letter to EFI

In an **elevated Command Prompt**:

```cmd
diskpart
list disk
select disk X   ← (replace X with the disk number containing the EFI partition)
list partition
select partition Y  ← (replace Y with the EFI System Partition number)
assign letter=Z
exit
```

Now the EFI partition is accessible at **Z:**

---

### 4. Rebuild the Windows Boot Manager

Still in the elevated Command Prompt:

```cmd
bcdboot C:\Windows /s Z: /f UEFI
bcdboot D:\Windows /s Z: /f UEFI
```

* Replace **C:** and **D:** with the actual drive letters for your Windows 10 and Windows 11 installations.
* This copies the boot files for both into the EFI partition.

---

### 5. Make UEFI boot from Windows Boot Manager

Run:

```cmd
bcdedit /enum firmware
```

Find the **Windows Boot Manager** entry, note its identifier, then:

```cmd
bcdedit /set {fwbootmgr} bootsequence {identifier}
```

Or simply enter BIOS setup and manually set **Windows Boot Manager** as the first boot option.

---

### 6. Remove GRUB from boot order (optional)

In BIOS, delete the Ubuntu/GRUB boot entry or move it below Windows Boot Manager.

---

✅ **After reboot:**
You should now get the **Windows Boot Manager** menu showing both Windows 10 and Windows 11, no more GRUB prompt.

---

If you want, I can help you figure out the **exact drive letters** for both Windows installs so you don’t accidentally point `bcdboot` to the wrong folder.
Do you want me to walk you through checking that? That’s the step where most people mess things up.
