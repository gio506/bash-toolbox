#!/usr/bin/env bats

setup() {
  ROOT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.." && pwd)"
  TMP_DIR="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "backup_dir prints usage with --help" {
  run "$ROOT_DIR/bin/backup_dir" --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage: backup_dir"* ]]
}

@test "rotate_logs keeps requested number of files" {
  mkdir -p "$TMP_DIR/logs"
  for i in 1 2 3; do
    echo "x" > "$TMP_DIR/logs/app$i.log"
    sleep 1
  done

  run "$ROOT_DIR/bin/rotate_logs" "$TMP_DIR/logs" 1
  [ "$status" -eq 0 ]

  remaining=$(find "$TMP_DIR/logs" -name '*.log' | wc -l | tr -d ' ')
  [ "$remaining" -eq 1 ]
}

@test "json_pretty fails with missing file" {
  run "$ROOT_DIR/bin/json_pretty" "$TMP_DIR/missing.json"
  [ "$status" -eq 1 ]
  [[ "$output" == *"JSON file not found"* ]]
}
