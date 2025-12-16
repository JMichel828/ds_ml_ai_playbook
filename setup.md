# Environment Setup

This document explains how to set up, activate, and manage the local Python virtual
environment for this repository.

The goal is to keep the environment lightweight, reproducible, and consistent across machines.

---

## Prerequisites

- Python 3.10+ recommended
- Git
- PowerShell (Windows) or a standard terminal (Mac/Linux)

Verify Python is installed:

```bash
python --version
```

---

## 1. Create the Virtual Environment

From the **root of the repository**:

### Windows (PowerShell)

```powershell
python -m venv venv
```

### Mac / Linux

```bash
python3 -m venv venv
```

This creates a local virtual environment in the `venv/` directory.

---

## 2. Activate the Virtual Environment

### Windows (PowerShell)

```powershell
venv\Scripts\Activate
```

### Mac / Linux

```bash
source venv/bin/activate
```

After activation, your terminal prompt should show:

```
(venv)
```

---

## 3. Install Dependencies

With the virtual environment **activated**, install dependencies from `requirements.txt`:

```bash
pip install -r requirements.txt
```

This installs all required Python packages for notebooks, experiments, and examples.

---

## 4. Verify Installation (Optional)

```bash
pip list
```

You should see common data science libraries (e.g., numpy, pandas, scikit-learn).

---

## 5. Deactivate the Virtual Environment

When finished working in the repo:

```bash
deactivate
```

This returns your shell to the system Python environment.

---

## Notes & Common Issues

### Virtual Environment Breakage After Moving the Repo

If the repository directory is **renamed or moved**, the virtual environment may stop working.

This is expected behavior on Windows because virtual environments store absolute paths.

If you encounter errors such as:

```
Fatal error in launcher: Unable to create process ...
```

Fix it by deleting and recreating the virtual environment:

```powershell
deactivate
Remove-Item venv -Recurse -Force
python -m venv venv
venv\Scripts\Activate
pip install -r requirements.txt
```

---

## Repository Conventions

- The `venv/` directory is intentionally **not committed** to Git.
- Keep notebooks and scripts runnable using **only** packages listed in `requirements.txt`.
- If dependencies change, update `requirements.txt` and reinstall.

This setup is intentionally simple to minimize friction during prep.
