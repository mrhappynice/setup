# vLLM

In your project directory, run:

```bash
uv venv --python 3.11
```

```bash
source .venv/bin/activate
```

```bash
uv pip install vllm
```
---
---
---
Assuming you have UV installed, you can use it both to add VLLM to your project’s dependency list and then run it in your managed environment. For example:

1. **Install VLLM:**  
   This command adds VLLM as a dependency (updating your pyproject.toml and lock file) and synchronizes your virtual environment:
   ```
   uv add vllm
   ```

2. **Run VLLM:**  
   If VLLM installs a command‐line executable (as it does when installed via pip), you can run it directly with:
   ```
   uv run vllm --help
   ```
   (Replace `--help` with any arguments you need, for example, to specify a model or a prompt.)

Alternatively, if you prefer to invoke it as a Python module, you can use:
   ```
   uv run python -m vllm <your-arguments>
   ```

These two steps let you install and run VLLM within UV’s fast, automatically managed environment.
