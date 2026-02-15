#!/usr/bin/env bash
set -euo pipefail

# rotate_logs.sh
# Keep newest N .log files in a directory and remove older ones.
# Usage: ./bin/rotate_logs.sh <log_dir> [keep_count]

# Validate argument count.
if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <log_dir> [keep_count]" >&2
  exit 1
fi

log_dir=$1
# Keep the latest 5 logs by default.
keep_count=${2:-5}

# Validate target directory.
if [[ ! -d "$log_dir" ]]; then
  echo "Error: log directory '$log_dir' not found." >&2
  exit 1
fi

# keep_count must be a non-negative integer.
if ! [[ "$keep_count" =~ ^[0-9]+$ ]]; then
  echo "Error: keep_count must be a non-negative integer." >&2
  exit 1
fi

# Collect logs sorted by modification time (newest first).
mapfile -t logs < <(find "$log_dir" -maxdepth 1 -type f -name '*.log' -printf '%T@ %p\n' | sort -nr | awk '{print $2}')

# Exit early if there is nothing to remove.
if (( ${#logs[@]} <= keep_count )); then
  echo "Nothing to rotate. Found ${#logs[@]} log(s), keeping $keep_count."
  exit 0
fi

# Delete only logs after the keep_count index.
for ((i=keep_count; i<${#logs[@]}; i++)); do
  rm -f "${logs[$i]}"
  echo "Removed old log: ${logs[$i]}"
done
