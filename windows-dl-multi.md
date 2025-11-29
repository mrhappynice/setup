Here are a few easy Windows-Terminal-friendly ways to download **multiple files from URLs**. Pick the method you prefer.

---

# ✅ **Method 1: Using `curl` (built into Windows 10/11)**

Just run two commands—one per file:

```powershell
curl -L -o file1.ext "https://example.com/path/to/file1.ext"
curl -L -o file2.ext "https://example.com/path/to/file2.ext"
```

* `-L` = follow redirects
* `-o` = output filename

If you want them in a specific folder:

```powershell
curl -L -o "C:\Downloads\file1.ext" "https://example.com/file1.ext"
curl -L -o "C:\Downloads\file2.ext" "https://example.com/file2.ext"
```

---

# ✅ **Method 2: Using PowerShell’s `Invoke-WebRequest`**

```powershell
Invoke-WebRequest "https://example.com/file1.ext" -OutFile "file1.ext"
Invoke-WebRequest "https://example.com/file2.ext" -OutFile "file2.ext"
```

---

# ✅ **Method 3: Download multiple URLs from a list**

If you have both URLs, you can do:

```powershell
$urls = @(
    "https://example.com/file1.ext",
    "https://example.com/file2.ext"
)

foreach ($u in $urls) {
    $name = Split-Path $u -Leaf
    Invoke-WebRequest $u -OutFile $name
}
```

---
