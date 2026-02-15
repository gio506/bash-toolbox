#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR"

echo "[1/3] Syntax checks"
for script in bin/*.sh tests/*.sh; do
  bash -n "$script"
done

echo "[2/3] Help output checks"
./bin/backup_dir.sh --help >/dev/null
./bin/rotate_logs.sh --help >/dev/null
./bin/json_pretty.sh --help >/dev/null
./bin/ping_sweep.sh --help >/dev/null
./bin/disk_report.sh --help >/dev/null

echo "[3/3] Basic execution checks"
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

mkdir -p "$workdir/srcdir"
echo "hello" > "$workdir/srcdir/file.txt"
./bin/backup_dir.sh "$workdir/srcdir" "$workdir/backups" >/dev/null
find "$workdir/backups" -name 'srcdir_*.tar.gz' | grep -q .

json_out=$(echo '{"a":1}' | ./bin/json_pretty.sh)
[[ "$json_out" == *'"a": 1'* ]]

mkdir -p "$workdir/logs"
echo "line" > "$workdir/logs/app.log"
./bin/rotate_logs.sh "$workdir/logs" 2 >/dev/null
find "$workdir/logs" -name 'app.log.*.gz' | grep -q .

disk_out=$(./bin/disk_report.sh "$workdir")
[[ "$disk_out" == *'Disk usage summary'* ]]

./bin/ping_sweep.sh 127.0.0 1 1 0 >/dev/null || true

echo "All tests passed."
