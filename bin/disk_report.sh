#!/usr/bin/env bash
set -euo pipefail

path=${1:-.}

if [[ ! -d "$path" ]]; then
  echo "Error: directory '$path' not found." >&2
  exit 1
fi

echo "Disk usage report for: $path"
echo "Generated at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

echo "== Filesystem usage =="
df -h "$path"
echo

echo "== Largest items (top 10) =="
du -ah "$path" 2>/dev/null | sort -hr | head -n 10
