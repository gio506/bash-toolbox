# bash-toolbox

A compact collection of practical Bash CLI tools for common DevOps tasks.

## Tools

### 1) `backup_dir.sh`
Create a timestamped `tar.gz` backup of a directory.

```bash
./bin/backup_dir.sh /etc /tmp/backups
```

### 2) `rotate_logs.sh`
Compress `*.log` files and keep only a fixed number of newest archives.

```bash
./bin/rotate_logs.sh /var/log/myapp 7
```

### 3) `json_pretty.sh`
Pretty-print JSON via `python -m json.tool`.

```bash
echo '{"service":"api","ok":true}' | ./bin/json_pretty.sh
./bin/json_pretty.sh ./payload.json
```

### 4) `ping_sweep.sh`
Safe, rate-limited ping sweep (one host at a time + delay).

```bash
./bin/ping_sweep.sh 192.168.1 1 20 0.2
```

### 5) `disk_report.sh`
Show disk free summary and largest entries in a path.

```bash
./bin/disk_report.sh /var
```

## Safety notes

- Always validate target paths before running backup or log rotation in production.
- `ping_sweep.sh` is intentionally serial and delayed to reduce network load.
- Run scripts with least privileges required.
- Prefer testing scripts in a non-production environment first.
- Review compressed log retention count to avoid accidental data loss.

## Tests

Run local checks:

```bash
./tests/run_tests.sh
```

## Repository tree

```text
bash-toolbox/
├── .github/workflows/ci.yml      # CI pipeline: ShellCheck + tests
├── bin/
│   ├── backup_dir.sh             # Creates timestamped tar.gz backups
│   ├── rotate_logs.sh            # Compresses and trims rotated log archives
│   ├── json_pretty.sh            # Formats JSON using python -m json.tool
│   ├── ping_sweep.sh             # Rate-limited serial ICMP reachability sweep
│   └── disk_report.sh            # Disk summary and top space consumers
├── tests/
│   └── run_tests.sh              # Syntax and smoke tests for all tools
├── CHEATSHEET.md                 # Quick command reference for each script
└── README.md                     # Project documentation and usage examples
```
