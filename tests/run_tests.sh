#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail() { echo "[FAIL] $1" >&2; exit 1; }
pass() { echo "[PASS] $1"; }

echo "Running bash syntax checks..."
for script in bin/* lib/*.sh tests/run_tests.sh install.sh; do
  bash -n "$script" || fail "Syntax check failed: $script"
done
pass "bash -n syntax checks"

echo "Running smoke checks..."
workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

mkdir -p "$workdir/src" "$workdir/backups"
echo "demo" > "$workdir/src/file.txt"
archive_path=$(./bin/backup_dir "$workdir/src" "$workdir/backups")
[[ -f "$archive_path" ]] || fail "backup_dir archive missing"
pass "backup_dir"

mkdir -p "$workdir/logs"
for i in 1 2 3 4; do
  echo "log $i" > "$workdir/logs/app$i.log"
  sleep 1
done
./bin/rotate_logs "$workdir/logs" 2 >/dev/null
remaining_logs=$(find "$workdir/logs" -maxdepth 1 -type f -name '*.log' | wc -l | tr -d ' ')
[[ "$remaining_logs" == "2" ]] || fail "rotate_logs should keep 2 logs"
pass "rotate_logs"

echo '{"hello":"world"}' > "$workdir/sample.json"
json_output=$(./bin/json_pretty "$workdir/sample.json")
echo "$json_output" | grep -q '"hello": "world"' || fail "json_pretty output"
pass "json_pretty"

disk_output=$(./bin/disk_report "$workdir")
echo "$disk_output" | grep -q "Disk usage report" || fail "disk_report output"
pass "disk_report"

./bin/ping_sweep 127.0.0 1 1 | grep -Eq 'UP|DOWN' || fail "ping_sweep output"
pass "ping_sweep"

echo "All smoke checks passed."
