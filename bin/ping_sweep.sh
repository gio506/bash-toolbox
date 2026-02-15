#!/usr/bin/env bash
set -euo pipefail

# ping_sweep.sh: safely sweep a small IP range with rate-limited ping requests.

usage() {
  cat <<'USAGE'
Usage: ping_sweep.sh <prefix> [start_host] [end_host] [delay_seconds]
Example: ping_sweep.sh 192.168.1 1 20 0.2
Notes:
  - prefix must be 3 octets (e.g., 192.168.1)
  - default host range: 1..254
  - default delay between pings: 0.2s (rate-limited)
  - maximum sweep size: 64 hosts per run (safety guardrail)
USAGE
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 4 ]]; then
  usage
  exit 1
fi

if ! command -v ping >/dev/null 2>&1; then
  echo "Error: ping command is required but not found." >&2
  exit 1
fi

if ! command -v sleep >/dev/null 2>&1; then
  echo "Error: sleep command is required but not found." >&2
  exit 1
fi

prefix=$1
start_host=${2:-1}
end_host=${3:-254}
delay=${4:-0.2}

if [[ ! "$prefix" =~ ^([0-9]{1,3}\.){2}[0-9]{1,3}$ ]]; then
  echo "Error: prefix must look like X.Y.Z" >&2
  exit 1
fi

IFS='.' read -r o1 o2 o3 <<< "$prefix"
for octet in "$o1" "$o2" "$o3"; do
  if (( octet < 0 || octet > 255 )); then
    echo "Error: invalid octet in prefix." >&2
    exit 1
  fi
done

if [[ ! "$start_host" =~ ^[0-9]+$ || ! "$end_host" =~ ^[0-9]+$ ]]; then
  echo "Error: host range must be numeric." >&2
  exit 1
fi

if (( start_host < 1 || end_host > 254 || start_host > end_host )); then
  echo "Error: host range must be 1..254 and start <= end." >&2
  exit 1
fi

if ! [[ "$delay" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
  echo "Error: delay must be a positive number." >&2
  exit 1
fi

host_count=$(( end_host - start_host + 1 ))
if (( host_count > 64 )); then
  echo "Error: refusing to scan more than 64 hosts in one run." >&2
  exit 1
fi

echo "Sweeping ${prefix}.${start_host}-${end_host} with ${delay}s delay..."
for ((h=start_host; h<=end_host; h++)); do
  ip="${prefix}.${h}"
  if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
    echo "$ip is up"
  fi
  sleep "$delay"
done
