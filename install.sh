#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[tmux] %s\n' "$*"
}

need_cmd() {
  local cmd="$1"
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    printf '[tmux] ERROR: missing %s (install via brew)\n' "${cmd}" >&2
    exit 1
  fi
}

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_SRC="${ROOT_DIR}/.tmux.conf"
TMUX_CONF_DEST="${HOME}/.tmux.conf"

if [[ -L "${TMUX_CONF_DEST}" && "$(readlink "${TMUX_CONF_DEST}")" == "${TMUX_CONF_SRC}" ]]; then
  log "Symlink already set: ${TMUX_CONF_DEST} -> ${TMUX_CONF_SRC}"
else
  if [[ -e "${TMUX_CONF_DEST}" || -L "${TMUX_CONF_DEST}" ]]; then
    backup_dir="${HOME}/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "${backup_dir}"
    mv "${TMUX_CONF_DEST}" "${backup_dir}/"
    log "Backed up existing ${TMUX_CONF_DEST} to ${backup_dir}"
  fi
  ln -s "${TMUX_CONF_SRC}" "${TMUX_CONF_DEST}"
  log "Linked ${TMUX_CONF_DEST} -> ${TMUX_CONF_SRC}"
fi

need_cmd cmake
need_cmd make

BUILD_DIR="${ROOT_DIR}/vendor/tmux-mem-cpu-load/build"
INSTALL_PREFIX="${HOME}/.local"

mkdir -p "${INSTALL_PREFIX}/bin"
cmake -S "${ROOT_DIR}/vendor/tmux-mem-cpu-load" -B "${BUILD_DIR}" -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}"
cmake --build "${BUILD_DIR}"
cmake --install "${BUILD_DIR}"

if command -v tmux >/dev/null 2>&1; then
  tmux source-file "${TMUX_CONF_DEST}" 2>/dev/null || true
fi

log "Done."
