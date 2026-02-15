#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 3 ]]; then
  echo "Usage: $0 <subnet_prefix> [start_host] [end_host]" >&2
  echo "Example: $0 192.168.1 1 10" >&2
  exit 1
fi

subnet_prefix=$1
start_host=${2:-1}
end_host=${3:-20}

if ! [[ "$subnet_prefix" =~ ^([0-9]{1,3}\.){2}[0-9]{1,3}$ ]]; then
  echo "Error: subnet prefix must look like x.x.x (example: 192.168.1)." >&2
  exit 1
fi

if ! [[ "$start_host" =~ ^[0-9]+$ && "$end_host" =~ ^[0-9]+$ ]]; then
  echo "Error: start_host and end_host must be integers." >&2
  exit 1
fi

if (( start_host < 1 || end_host > 254 || start_host > end_host )); then
  echo "Error: host range must be within 1-254 and start <= end." >&2
  exit 1
fi

for host in $(seq "$start_host" "$end_host"); do
  ip="${subnet_prefix}.${host}"
  if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
    echo "UP   $ip"
  else
    echo "DOWN $ip"
  fi
  sleep 0.2
done
