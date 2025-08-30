---

# Installing pyenv on Unix-like Systems (Linux and macOS)

---

## 1. Install Dependencies (Optional but Recommended)

While pyenv itself is a shell script, installing various Python versions often requires build tools and libraries.
On **Ubuntu/Debian**, you might need:

```bash
sudo apt update
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
libffi-dev liblzma-dev
```

Similar packages exist for other distributions.

---

## 2. Install pyenv

The recommended way is to use the **pyenv-installer** script:

```bash
curl https://pyenv.run | bash
```

---

## 3. Configure Shell Environment

After installation, add pyenv to your shell’s environment variables.
For **Bash** (`~/.bashrc`):

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
```

For **Zsh**, replace `~/.bashrc` with `~/.zshrc`.

Reload your shell configuration:

```bash
source ~/.bashrc
# or
source ~/.zshrc
```

---

## 4. Install Python Versions

Once pyenv is set up, you can install specific Python versions:

```bash
pyenv install 3.9.18
pyenv install 3.10.14
```

---

## 5. Set Python Version

You can set a **global** Python version or a **local** one for a specific project:

```bash
pyenv global 3.9.18   # Sets a global default
pyenv local 3.10.14   # Sets for the current directory
```

---

## Windows Users

`pyenv` does not officially support Windows.
Instead, use **[pyenv-win](https://github.com/pyenv-win/pyenv-win)**, a separate project designed for Windows.

Installation methods for pyenv-win include **PowerShell**, **Git**, or **pip**. Refer to the pyenv-win documentation for detailed instructions.

---

Do you also want me to generate that **short cheat sheet version** I mentioned — just the commands in order, no explanations — so it’s easier to copy-paste when setting up?
