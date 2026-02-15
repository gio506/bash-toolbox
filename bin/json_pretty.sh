#!/usr/bin/env bash
set -euo pipefail

# json_pretty.sh
# Pretty-print JSON via Python's standard library.
# Usage: ./bin/json_pretty.sh <json_file>

# Require exactly one JSON file argument.
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <json_file>" >&2
  exit 1
fi

json_file=$1

# Validate input file presence.
if [[ ! -f "$json_file" ]]; then
  echo "Error: file '$json_file' not found." >&2
  exit 1
fi

# python -m json.tool validates + pretty-prints JSON.
python -m json.tool "$json_file"
