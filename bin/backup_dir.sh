#!/usr/bin/env bash
set -euo pipefail

# backup_dir.sh
# Create a timestamped .tar.gz archive from a source directory.
# Usage: ./bin/backup_dir.sh <source_dir> [dest_dir]

# Validate argument count.
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <source_dir> [dest_dir]" >&2
  exit 1
fi

source_dir=$1
# Default destination to current directory when omitted.
dest_dir=${2:-.}

# Guard rails: require existing source/destination directories.
if [[ ! -d "$source_dir" ]]; then
  echo "Error: source directory '$source_dir' not found." >&2
  exit 1
fi

if [[ ! -d "$dest_dir" ]]; then
  echo "Error: destination directory '$dest_dir' not found." >&2
  exit 1
fi

# Build archive file name: <source>_backup_<timestamp>.tar.gz
source_name=$(basename "$source_dir")
timestamp=$(date +%Y%m%d_%H%M%S)
archive_path="$dest_dir/${source_name}_backup_${timestamp}.tar.gz"

# Use -C so the archive contains a clean top-level folder name.
tar -czf "$archive_path" -C "$(dirname "$source_dir")" "$source_name"
echo "Backup created: $archive_path"
