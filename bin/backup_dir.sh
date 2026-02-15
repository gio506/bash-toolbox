#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $(basename "$0") <source_dir> <backup_root>

Creates a timestamped tar.gz backup of <source_dir> under <backup_root>.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 2 ]]; then
  usage >&2
  exit 1
fi

src=$1
backup_root=$2

if [[ ! -d "$src" ]]; then
  echo "Error: source directory '$src' not found." >&2
  exit 1
fi

mkdir -p "$backup_root"

base_name=$(basename "$(realpath "$src")")
timestamp=$(date +"%Y%m%d_%H%M%S")
out_file="$backup_root/${base_name}_${timestamp}.tar.gz"

tar -czf "$out_file" -C "$(dirname "$(realpath "$src")")" "$base_name"

echo "Backup created: $out_file"
