# CHEATSHEET

Use this file as the quick command map after reading `README.md`.

## Common flags (all tools)

- `-h, --help`
- `-q, --quiet`
- `-v, --verbose`
- `--no-color`
- `--version`

## Commands

```bash
backup_dir <source_dir> [dest_dir]
rotate_logs <log_dir> [keep_count]
json_pretty <json_file>
ping_sweep <subnet_prefix> [start_host] [end_host]
disk_report [path]
```

## Validation commands

```bash
chmod +x bin/* tests/*.sh install.sh
bash tests/run_tests.sh
shellcheck bin/* lib/*.sh tests/run_tests.sh
bats tests/bats
make package-check
```

## Useful commands

```bash
# Keep only 2 newest logs
rotate_logs /var/log/myapp 2

# Backup and then inspect archive contents
archive=$(backup_dir ./my-data ./backups)
tar -tzf "$archive" | head

# Pretty-print and validate JSON
json_pretty ./payload.json

# Low-impact single-host check
ping_sweep 127.0.0 1 1

# Disk report in current folder
disk_report .
```

## Safety quick reminders

- Use network scans only where you have explicit authorization.
- `rotate_logs` deletes files permanently.
- Confirm free space before creating backups.
- Prefer testing with temporary directories before using real data.
