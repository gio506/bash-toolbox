#!/usr/bin/env bash
set -euo pipefail

# json_pretty.sh: pretty-print JSON from a file or stdin using python -m json.tool.

usage() {
  cat <<'USAGE'
Usage: json_pretty.sh [json_file]
Pretty-print JSON using: python -m json.tool
If no file is provided, reads JSON from stdin.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -gt 1 ]]; then
  usage
  exit 1
fi

if ! command -v python >/dev/null 2>&1; then
  echo "Error: python command is required but not found." >&2
  exit 1
fi

if [[ $# -eq 1 ]]; then
  if [[ ! -f "$1" ]]; then
    echo "Error: JSON file not found: $1" >&2
    exit 1
  fi
  python -m json.tool "$1"
else
  python -m json.tool
fi
