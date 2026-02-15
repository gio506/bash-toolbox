#!/usr/bin/env bash
set -euo pipefail

# disk_report.sh: report filesystem usage and largest directories for a given path.

usage() {
  cat <<'USAGE'
Usage: disk_report.sh [path] [top_n]
Show disk free space and largest directories under [path] (default: .).
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if ! command -v df >/dev/null 2>&1 || ! command -v du >/dev/null 2>&1; then
  echo "Error: df and du commands are required." >&2
  exit 1
fi

path=${1:-.}
top_n=${2:-10}

if [[ ! -d "$path" ]]; then
  echo "Error: directory not found: $path" >&2
  exit 1
fi

if [[ ! "$top_n" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: top_n must be a positive integer." >&2
  exit 1
fi

echo "== Filesystem usage =="
df -h "$path"

echo
echo "== Largest directories in $path (top $top_n) =="
du -h --max-depth=1 "$path" 2>/dev/null | sort -hr | head -n "$top_n"
