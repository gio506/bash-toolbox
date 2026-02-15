# Bash Toolbox Cheatsheet

Quick reminders for what each tool is for and how to run it.

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
