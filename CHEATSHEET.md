# Bash Toolbox Cheatsheet

Quick reminders for what each tool is for and how to run it.

## Tool purpose map

- `bin/backup_dir.sh <source_dir> [dest_dir]`
  - Purpose: Create a compressed timestamped backup archive.
- `bin/rotate_logs.sh <log_dir> [keep_count]`
  - Purpose: Keep latest `.log` files and remove older ones.
- `bin/json_pretty.sh <json_file>`
  - Purpose: Validate and pretty-print JSON.
- `bin/ping_sweep.sh <subnet_prefix> [start_host] [end_host]`
  - Purpose: Ping a small host range with built-in delay.
- `bin/disk_report.sh [path]`
  - Purpose: Show filesystem usage and largest files/directories.

## Fast examples

```bash
./bin/backup_dir.sh ./data ./backups
./bin/rotate_logs.sh ./logs 5
./bin/json_pretty.sh ./payload.json
./bin/ping_sweep.sh 10.0.0 1 20
./bin/disk_report.sh /tmp
```

## Useful commands

```bash
# Make all scripts executable (if needed)
chmod +x bin/*.sh

# Run all local checks
bash tests/run_tests.sh

# Syntax-check scripts directly
bash -n bin/*.sh tests/*.sh

# Example: inspect archive contents without extracting
tar -tzf ./backups/src_backup_20250101_120000.tar.gz | head

# Example: create demo logs then rotate to keep newest 2
mkdir -p /tmp/demo-logs && for i in {1..5}; do echo "x" > "/tmp/demo-logs/app$i.log"; sleep 1; done
./bin/rotate_logs.sh /tmp/demo-logs 2

# Example: pretty-print JSON from stdin via temp file
cat payload.json | tee /tmp/payload.json >/dev/null && ./bin/json_pretty.sh /tmp/payload.json

# Example: safe single-host ping check
./bin/ping_sweep.sh 127.0.0 1 1

# Example: report disk usage for current folder
./bin/disk_report.sh .
```

## Safety quick reminders

- Use network scans only where you have explicit authorization.
- `rotate_logs.sh` deletes files permanently.
- Confirm free space before creating backups.
