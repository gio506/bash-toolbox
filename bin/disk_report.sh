#!/usr/bin/env bash
set -euo pipefail

# disk_report.sh
# Print filesystem usage and largest files/directories under a path.
# Usage: ./bin/disk_report.sh [path]

# Default to current directory.
path=${1:-.}

# Validate target path.
if [[ ! -d "$path" ]]; then
  echo "Error: directory '$path' not found." >&2
  exit 1
fi

echo "Disk usage report for: $path"
echo "Generated at: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo

# Filesystem-level usage (partition/capacity view).
echo "== Filesystem usage =="
df -h "$path"
echo

# Directory/file-level hot spots.
echo "== Largest items (top 10) =="
du -ah "$path" 2>/dev/null | sort -hr | head -n 10
