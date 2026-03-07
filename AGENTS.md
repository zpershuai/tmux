# Repository Guidelines

## Project Structure & Module Organization
- `.tmux.conf` is the main tmux configuration and primary change surface.
- `.tmux-osx.conf` contains macOS-specific overrides.
- `install.sh` performs setup: backs up existing `~/.tmux.conf`, creates the symlink, and builds `vendor/tmux-mem-cpu-load`.
- `scripts/` contains helper scripts (for example `scripts/resize-adaptable.sh` for layout resizing).
- `plugins/` holds plugin checkouts/symlinks used by TPM.
- `vendor/` contains third-party code; avoid editing unless intentionally vendoring upstream changes.

## Build, Test, and Development Commands
- `./install.sh`: full local setup, build, and install flow.
- `cmake -S vendor/tmux-mem-cpu-load -B vendor/tmux-mem-cpu-load/build -DCMAKE_INSTALL_PREFIX="$HOME/.local"`: configure native status binary.
- `cmake --build vendor/tmux-mem-cpu-load/build && cmake --install vendor/tmux-mem-cpu-load/build`: compile and install `tmux-mem-cpu-load`.
- `tmux source-file ~/.tmux.conf`: reload config in a running tmux server.
- `bash -n install.sh scripts/resize-adaptable.sh`: quick shell syntax validation before committing.

## Coding Style & Naming Conventions
- Shell scripts should use POSIX/Bash-safe patterns already present in this repo (`set -euo pipefail` for Bash scripts, quoted variables, helper functions).
- Keep indentation consistent with existing files (2 spaces in `install.sh`, tabs/spaces as already used in legacy scripts).
- Name scripts with lowercase kebab-case (example: `resize-adaptable.sh`).
- Keep tmux bindings and options grouped by concern (status, panes, keybinds, plugins) and add brief comments only where behavior is non-obvious.

## Testing Guidelines
- There is no formal automated test suite for tmux config changes.
- Validate changes manually:
  1. Run syntax checks (`bash -n ...`).
  2. Reload tmux config (`tmux source-file ~/.tmux.conf`).
  3. Exercise changed bindings/options in an interactive tmux session.
- If touching `vendor/tmux-mem-cpu-load`, ensure the CMake build succeeds on your target OS.

## Commit & Pull Request Guidelines
- Follow the existing commit style: short, imperative summaries (example: `update tmux`, `add navigate key`).
- Keep commits focused (config changes, script changes, and vendor updates separated when possible).
- PRs should include:
  - What changed and why.
  - Any new/modified key bindings.
  - Validation steps run (`./install.sh`, reload, manual checks).
  - Platform notes (especially macOS vs Linux behavior).
