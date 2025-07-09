Below is a brief overview of why you can’t use your Kasm login password for `sudo` and how to get a root shell.

## 1. No Default sudo Password for `kasm-user`

By design, Kasm workspaces run as an unprivileged user (`kasm-user`) with **no** Linux password set on that account—even the root account inside the container has no password. As a result, attempting:

```bash
sudo <command>
```

and entering your Kasm workspace password will always fail, because there simply is no password to check against. ([brandenwilliams.com][1])

## 2. Two Ways to Obtain Root Access

### A. Run the Entire Workspace as Root

1. In the **Kasm Admin UI** go to **Workspaces → Workspaces**.
2. Edit the workspace you’re using.
3. In **Docker Run Config Override**, set:

   ```json
   {
     "hostname":"kasm",
     "user":"root"
   }
   ```
4. Save and relaunch. Inside VS Code’s terminal, `whoami` will now print `root`. ([kasmweb.com][2])

> **Note:** Some GUI apps (e.g. Firefox) may refuse to run as root, and this reduces container isolation.

### B. Enable Password-less `sudo` for `kasm-user`

If you only need occasional root commands, you can leave the desktop session as `kasm-user` and grant it sudo rights without a password:

1. In the **Kasm Admin UI** go to **Workspaces → Workspaces**.
2. Edit the workspace and locate **Docker Exec Config**.
3. Drop in:

   ```json
   {
     "first_launch": {
       "user":"root",
       "cmd":"bash -c 'apt-get update && apt-get install -y sudo && echo \"kasm-user ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers'"
     }
   }
   ```
4. Save and relaunch. Now as `kasm-user`, you can run `sudo <command>` with no password prompt. ([brandenwilliams.com][1], [kasmweb.com][2])

> **Tip:** You can also set an actual password for `kasm-user` by adding something like
> `&& echo "kasm-user:YourChosenPassword" | chpasswd`
> into the same `cmd` sequence, if you prefer the traditional sudo-with-password flow.

---

### Why Your Workspace Password Fails

* **Workspace login password** is for authenticating your browser session against the Kasm server.
* **`kasm-user` Linux account** inside the container has **no** password set.

They are completely separate credentials, so entering your workspace password at a sudo prompt will never work.

[1]: https://www.brandenwilliams.com/blog/2025/01/23/level-up-cybersecurity-with-kasm-workspaces/?utm_source=chatgpt.com "Level Up Cybersecurity with Kasm Workspaces"
[2]: https://kasmweb.com/docs/latest/how_to/running_as_root.html?utm_source=chatgpt.com "Running as Root — Kasm 1.17.0 documentation"
