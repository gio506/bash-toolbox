#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $(basename "$0") [path]

Shows disk free summary and top 10 largest entries in [path].
Default path: current directory
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -gt 1 ]]; then
  usage >&2
  exit 1
fi

path=${1:-.}

if [[ ! -e "$path" ]]; then
  echo "Error: path '$path' does not exist." >&2
  exit 1
fi

echo "=== Disk usage summary ==="
df -h "$path"

echo
echo "=== Top 10 largest entries in $path ==="
{ du -h "$path" 2>/dev/null | sort -hr | head -n 10; } || true
