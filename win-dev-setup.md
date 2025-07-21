Here’s a one-stop checklist and step-by-step guide for setting up a Windows 11 machine capable of developing in Node.js, Python, and C:

---

## 1. Install a Package Manager (optional but recommended)

Using a Windows package manager makes installs/updates a breeze. Two popular choices:

* **Chocolatey**
  Open PowerShell **as Administrator** and run:

  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = `
      [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  ```
* **Scoop**
  Open PowerShell **as your user** and run:

  ```powershell
  iwr -useb get.scoop.sh | iex
  ```

> Once installed, you can `choco install` or `scoop install` everything below with one command each.

---

## 2. Install Node.js (with npm)

**Why?** Node.js comes with npm (the Node package manager) and allows running JavaScript on the server.

* **Via Installer**
  Download the LTS (“Long Term Support”) MSI from [https://nodejs.org](https://nodejs.org) and run it.
* **Via Chocolatey**

  ```powershell
  choco install nodejs-lts
  ```
* **Via Scoop**

  ```powershell
  scoop install nodejs-lts
  ```

**Verify:**

```powershell
node –-version    # e.g. v18.x.x
npm –-version     # e.g. 9.x.x
```

---

## 3. Install Python

**Why?** Python 3 is essential for scripting, data work, web backends, and more.

* **Via Installer**
  Download the latest 3.x installer from [https://python.org/downloads/windows](https://python.org/downloads/windows).
  **Important:** check “Add Python to PATH” during setup.
* **Via Microsoft Store**
  Open Store → search “Python 3.x” → Install.
* **Via Chocolatey**

  ```powershell
  choco install python
  ```
* **Via Scoop**

  ```powershell
  scoop install python
  ```

**Verify:**

```powershell
python --version  # e.g. Python 3.11.x
pip --version     # e.g. pip 23.x
```

> **Tip:** Consider using [venv](https://docs.python.org/3/library/venv.html) or [pipx](https://pypa.github.io/pipx/) to isolate project dependencies.

---

## 4. Install a C Compiler & Build Tools

**Why?** To compile C code (and to compile native Node modules or Python extensions).

* **Visual Studio Build Tools (recommended)**

  1. Download the **Build Tools for Visual Studio** from [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/) (look under “Tools for Visual Studio”).
  2. In the installer, select **“C++ build tools”** workload.
  3. Make sure the **Windows 10/11 SDK** is checked.
* **Visual Studio Community**
  If you want an IDE, grab the free Community edition and select the same “Desktop development with C++” workload.
* **Verify from “Developer Command Prompt for VS”**

  ```shell
  cl
  ```

  Should show the MSVC compiler help.

---

## 5. Git & Version Control

**Why?** Source control is essential.

* **Installer:** [https://git-scm.com/download/win](https://git-scm.com/download/win)
* **Chocolatey:**

  ```powershell
  choco install git
  ```
* **Scoop:**

  ```powershell
  scoop install git
  ```
* **Verify:**

  ```powershell
  git --version
  ```

---

## 6. A Good Editor/IDE

* **VS Code** (lightweight, extensible):

  ```powershell
  choco install vscode
  ```
* **Visual Studio** (full IDE, if you need heavy debugging/profiling for C++)

---

## 7. (Optional) Windows Subsystem for Linux (WSL 2)

Run genuine Linux distros alongside Windows—handy for certain workflows or tooling that expect a POSIX environment.

```powershell
wsl --install
```

After reboot, select your distro (e.g. Ubuntu) and set it up.

---

## 8. Configure Your PATH & Environment

* Confirm that `node`, `npm`, `python`, `pip`, and `cl` (or `gcc` if you later install MinGW) are all available in your PowerShell/CMD.
* Consider enabling **Windows Terminal** from the Store for tabs and profiles.

---

## 9. Test a Quick “Hello World”

```bash
# Node
echo "console.log('hi node');" > hello.js
node hello.js

# Python
python - << 'EOF'
print("hi python")
EOF

# C
echo '#include <stdio.h>
int main(){ printf("hi c\n"); return 0; }' > hello.c
cl hello.c
.\hello.exe
```

---

### Summary of Key Installs

| Tool/Component        | Method                                         |
| --------------------- | ---------------------------------------------- |
| **Package Manager**   | Chocolatey / Scoop                             |
| **Node.js & npm**     | nodejs.org MSI or `choco install nodejs-lts`   |
| **Python 3.x**        | python.org installer or `choco install python` |
| **C/C++ Build Tools** | Visual Studio Build Tools (C++ workload)       |
| **Git**               | git-scm.com or `choco install git`             |
| **Editor**            | VS Code (`choco install vscode`)               |
| **WSL 2 (optional)**  | `wsl --install`                                |

With those in place, you’ll have a fully capable Windows 11 dev box for Node, Python, and native C work. Happy coding!
