#!/usr/bin/env bash
set -euo pipefail

# rotate_logs.sh: rotate a log file into numbered archives and truncate active log.

usage() {
  cat <<'USAGE'
Usage: rotate_logs.sh <log_file> [max_files]
Rotate <log_file> to .1, .2, ... keeping [max_files] archives (default: 5).
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

log_file=$1
max_files=${2:-5}

if [[ ! "$max_files" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: max_files must be a positive integer." >&2
  exit 1
fi

if [[ ! -f "$log_file" ]]; then
  echo "Error: log file not found: $log_file" >&2
  exit 1
fi

for ((i=max_files; i>=1; i--)); do
  if [[ -f "${log_file}.${i}" ]]; then
    if (( i == max_files )); then
      rm -f "${log_file}.${i}"
    else
      mv "${log_file}.${i}" "${log_file}.$((i+1))"
    fi
  fi
done

mv "$log_file" "${log_file}.1"
: > "$log_file"

echo "Rotated: $log_file (kept $max_files files)"
