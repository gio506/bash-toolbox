#!/usr/bin/env bash
set -euo pipefail

# test_cli_tools.sh: run syntax and basic behavior checks for all CLI tools.

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

for script in "$ROOT_DIR"/bin/*.sh; do
  bash -n "$script"
done

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/src"
echo "hello" > "$tmp_dir/src/file.txt"
"$ROOT_DIR/bin/backup_dir.sh" "$tmp_dir/src" "$tmp_dir/backups" >/dev/null
test "$(find "$tmp_dir/backups" -name 'src_*.tar.gz' | wc -l)" -eq 1

echo "logline" > "$tmp_dir/app.log"
"$ROOT_DIR/bin/rotate_logs.sh" "$tmp_dir/app.log" 3 >/dev/null
test -f "$tmp_dir/app.log.1"
test ! -s "$tmp_dir/app.log"

printf '{"name":"toolbox"}' | "$ROOT_DIR/bin/json_pretty.sh" > "$tmp_dir/pretty.json"
grep -q '"name": "toolbox"' "$tmp_dir/pretty.json"

"$ROOT_DIR/bin/ping_sweep.sh" 127.0.0 1 1 0.01 > "$tmp_dir/ping.txt"
grep -q 'Sweeping 127.0.0.1-1' "$tmp_dir/ping.txt"

set +e
"$ROOT_DIR/bin/ping_sweep.sh" 127.0.0 1 100 0.01 >/dev/null 2>&1
status=$?
set -e
test "$status" -ne 0

"$ROOT_DIR/bin/disk_report.sh" "$tmp_dir" 5 > "$tmp_dir/disk.txt"
grep -q 'Filesystem usage' "$tmp_dir/disk.txt"

echo "All tests passed"
