To allow **large binary files in Gitea**, you typically need to adjust **three things**:

1. **Repository upload limits**
2. **Server reverse-proxy limits** (if using Nginx/Apache/Caddy)
3. **Git LFS** if binaries exceed normal Git comfort levels

Below is a concise guide.

---

# ✅ 1. Increase upload limits in Gitea

Edit your `app.ini` (usually in `/etc/gitea/app.ini` or `/var/lib/gitea/custom/conf/app.ini`):

```ini
[server]
MAX_SIZE = 1024
```

`MAX_SIZE` is in **MB**.
Example: allow 2GB pushes → `MAX_SIZE = 2048`.

---

# ✅ 2. Increase Git limits (optional but recommended)

```ini
[git]
MAX_GIT_SIZE = 4294967296   ; 4GB
DISABLE_DIFF_HIGHLIGHT = true
```

---

# ✅ 3. Enable/Configure Git LFS for large binaries (recommended)

Git alone does *not* handle large binaries efficiently.
Enable LFS:

```ini
[lfs]
ENABLED = true
CONTENT_PATH = /var/lib/gitea/data/lfs
MAX_FILE_SIZE = 2097152000  ; ~2GB
```

Then in your repo:

```bash
git lfs install
git lfs track "*.bin"
git add .gitattributes
git commit -m "Enable LFS"
```

---

# ✅ 4. If using a reverse proxy (Nginx/Apache/Caddy)

## **Nginx**

Add:

```nginx
client_max_body_size 2G;
```

## **Apache**

Add:

```apache
LimitRequestBody 0
```

## **Caddy**

Add:

```caddy
request_body {
    max_size 2GB
}
```

Restart the proxy after changing these.

---

# 🔍 Quick checklist

| Component       | What to change                     | Needed?             |
| --------------- | ---------------------------------- | ------------------- |
| Gitea `app.ini` | `MAX_SIZE`                         | ✔️ Required         |
| Git LFS         | Handle very large binaries         | ✔️ Recommended      |
| Nginx/Apache    | Increase upload limit              | ✔️ If using a proxy |
| Git client      | Maybe `git config http.postBuffer` | ❗ Rarely needed     |

Example of increasing Git client buffer (only if errors occur):

```bash
git config --global http.postBuffer 524288000
git config --global http.maxRequestBuffer 1000M
```

---

