#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $(basename "$0") <log_dir> [max_files]

Compresses *.log files and keeps only [max_files] newest compressed logs per base name.
Default max_files: 5
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage >&2
  exit 1
fi

log_dir=$1
max_files=${2:-5}

if [[ ! -d "$log_dir" ]]; then
  echo "Error: log directory '$log_dir' not found." >&2
  exit 1
fi

if ! [[ "$max_files" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: max_files must be a positive integer." >&2
  exit 1
fi

shopt -s nullglob
for file in "$log_dir"/*.log; do
  ts=$(date +"%Y%m%d_%H%M%S")
  gz="$file.$ts.gz"
  gzip -c "$file" > "$gz"
  : > "$file"
  echo "Rotated: $file -> $gz"
done

mapfile -t bases < <(find "$log_dir" -maxdepth 1 -type f -name '*.log.*.gz' -printf '%f\n' | sed -E 's/\.log\..*\.gz$//' | sort -u)

for base in "${bases[@]:-}"; do
  mapfile -t archives < <(find "$log_dir" -maxdepth 1 -type f -name "$base.log.*.gz" -printf '%f\n' | sort -r)
  if (( ${#archives[@]} > max_files )); then
    for old in "${archives[@]:max_files}"; do
      rm -f "$log_dir/$old"
      echo "Removed old archive: $log_dir/$old"
    done
  fi
done
