#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$ROOT_DIR/bin"
TARGET_DIR="/usr/local/bin"
TOOLS=(backup_dir rotate_logs json_pretty ping_sweep disk_report)

echo "This installer creates symlinks in $TARGET_DIR"
echo "Use only when you trust the working tree and have reviewed scripts."

if [[ "${1:-}" != "--yes" ]]; then
  echo "Dry-run complete. Re-run with --yes to apply symlinks."
  for tool in "${TOOLS[@]}"; do
    echo "ln -sf $BIN_DIR/$tool $TARGET_DIR/$tool"
  done
  exit 0
fi

for tool in "${TOOLS[@]}"; do
  sudo ln -sf "$BIN_DIR/$tool" "$TARGET_DIR/$tool"
  echo "Linked: $TARGET_DIR/$tool -> $BIN_DIR/$tool"
done

echo "Install complete."
