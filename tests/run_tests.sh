#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail() {
  echo "[FAIL] $1" >&2
  exit 1
}

pass() {
  echo "[PASS] $1"
}

echo "Running syntax checks..."
for script in bin/*.sh tests/*.sh; do
  bash -n "$script" || fail "Syntax check failed: $script"
done
pass "bash -n syntax checks"

echo "Running execution checks..."

workdir=$(mktemp -d)
trap 'rm -rf "$workdir"' EXIT

mkdir -p "$workdir/src" "$workdir/backups"
echo "demo" > "$workdir/src/file.txt"
backup_output=$(./bin/backup_dir.sh "$workdir/src" "$workdir/backups")
echo "$backup_output" | grep -q "Backup created" || fail "backup_dir output"
find "$workdir/backups" -name 'src_backup_*.tar.gz' | grep -q . || fail "backup_dir archive missing"
pass "backup_dir.sh"

mkdir -p "$workdir/logs"
for i in 1 2 3 4; do
  echo "log $i" > "$workdir/logs/app$i.log"
  sleep 1
done
./bin/rotate_logs.sh "$workdir/logs" 2 >/dev/null
remaining_logs=$(find "$workdir/logs" -maxdepth 1 -type f -name '*.log' | wc -l | tr -d ' ')
[[ "$remaining_logs" == "2" ]] || fail "rotate_logs should keep 2 logs"
pass "rotate_logs.sh"

echo '{"hello":"world"}' > "$workdir/sample.json"
json_output=$(./bin/json_pretty.sh "$workdir/sample.json")
echo "$json_output" | grep -q '"hello": "world"' || fail "json_pretty output"
pass "json_pretty.sh"

disk_output=$(./bin/disk_report.sh "$workdir")
echo "$disk_output" | grep -q "Disk usage report" || fail "disk_report output"
pass "disk_report.sh"

# Keep ping sweep tiny/safe for CI environments.
ping_output=$(./bin/ping_sweep.sh 127.0.0 1 1)
echo "$ping_output" | grep -Eq 'UP|DOWN' || fail "ping_sweep output"
pass "ping_sweep.sh"

echo "All tests passed."
