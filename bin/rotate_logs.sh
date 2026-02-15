#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <log_dir> [keep_count]" >&2
  exit 1
fi

log_dir=$1
keep_count=${2:-5}

if [[ ! -d "$log_dir" ]]; then
  echo "Error: log directory '$log_dir' not found." >&2
  exit 1
fi

if ! [[ "$keep_count" =~ ^[0-9]+$ ]]; then
  echo "Error: keep_count must be a non-negative integer." >&2
  exit 1
fi

shopt -s nullglob
mapfile -t logs < <(find "$log_dir" -maxdepth 1 -type f -name '*.log' -printf '%T@ %p\n' | sort -nr | awk '{print $2}')

if (( ${#logs[@]} <= keep_count )); then
  echo "Nothing to rotate. Found ${#logs[@]} log(s), keeping $keep_count."
  exit 0
fi

for ((i=keep_count; i<${#logs[@]}; i++)); do
  rm -f "${logs[$i]}"
  echo "Removed old log: ${logs[$i]}"
done
