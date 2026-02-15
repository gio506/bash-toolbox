#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <json_file>" >&2
  exit 1
fi

json_file=$1

if [[ ! -f "$json_file" ]]; then
  echo "Error: file '$json_file' not found." >&2
  exit 1
fi

python -m json.tool "$json_file"
