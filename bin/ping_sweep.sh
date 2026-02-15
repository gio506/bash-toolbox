#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<USAGE
Usage: $(basename "$0") <base_subnet> [start] [end] [delay_seconds]

Example: $(basename "$0") 192.168.1 1 20 0.1
Safely scans hosts with one ICMP probe at a time and configurable delay.
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 4 ]]; then
  usage >&2
  exit 1
fi

base=${1}
start=${2:-1}
end=${3:-254}
delay=${4:-0.2}

if ! [[ "$base" =~ ^([0-9]{1,3}\.){2}[0-9]{1,3}$ ]]; then
  echo "Error: base_subnet must look like X.Y.Z" >&2
  exit 1
fi

if ! [[ "$start" =~ ^[0-9]+$ && "$end" =~ ^[0-9]+$ && "$start" -ge 1 && "$end" -le 254 && "$start" -le "$end" ]]; then
  echo "Error: start/end must be valid host range 1..254 and start <= end" >&2
  exit 1
fi

for i in $(seq "$start" "$end"); do
  host="$base.$i"
  if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
    echo "UP   $host"
  else
    echo "DOWN $host"
  fi
  sleep "$delay"
done
