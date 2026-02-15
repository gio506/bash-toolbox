#!/usr/bin/env bash
set -euo pipefail

# backup_dir.sh: create a timestamped tar.gz backup for a source directory.

usage() {
  cat <<'USAGE'
Usage: backup_dir.sh <source_dir> <backup_dir>
Create a timestamped .tar.gz backup of <source_dir> in <backup_dir>.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 2 ]]; then
  usage
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "Error: tar command is required but not found." >&2
  exit 1
fi

src_dir=$1
backup_dir=$2

if [[ ! -d "$src_dir" ]]; then
  echo "Error: source directory not found: $src_dir" >&2
  exit 1
fi

mkdir -p "$backup_dir"

src_name=$(basename "$src_dir")
timestamp=$(date +"%Y%m%d_%H%M%S")
archive_path="$backup_dir/${src_name}_${timestamp}.tar.gz"

tar -czf "$archive_path" -C "$(dirname "$src_dir")" "$src_name"
echo "Backup created: $archive_path"
