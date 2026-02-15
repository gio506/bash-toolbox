#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <source_dir> [dest_dir]" >&2
  exit 1
fi

source_dir=$1
dest_dir=${2:-.}

if [[ ! -d "$source_dir" ]]; then
  echo "Error: source directory '$source_dir' not found." >&2
  exit 1
fi

if [[ ! -d "$dest_dir" ]]; then
  echo "Error: destination directory '$dest_dir' not found." >&2
  exit 1
fi

source_name=$(basename "$source_dir")
timestamp=$(date +%Y%m%d_%H%M%S)
archive_path="$dest_dir/${source_name}_backup_${timestamp}.tar.gz"

tar -czf "$archive_path" -C "$(dirname "$source_dir")" "$source_name"
echo "Backup created: $archive_path"
