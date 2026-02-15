# bash-toolbox

A small collection of practical Bash utilities for common DevOps workflows.

## Tools

### 1) `backup_dir.sh`
Creates a timestamped `tar.gz` backup of a source directory.

```bash
./bin/backup_dir.sh ./my-data ./backups
```

### 2) `rotate_logs.sh`
Rotates a log file into numbered archives and truncates the active file.

```bash
./bin/rotate_logs.sh /var/log/myapp.log 7
```

### 3) `json_pretty.sh`
Pretty-prints JSON using `python -m json.tool`.

```bash
./bin/json_pretty.sh payload.json
./bin/json_pretty.sh < payload.json
```

### 4) `ping_sweep.sh`
Performs a safe, rate-limited ping sweep over a small host range (max 64 hosts/run).

```bash
./bin/ping_sweep.sh 192.168.1 1 20 0.2
```

### 5) `disk_report.sh`
Shows filesystem usage and top largest directories under a path.

```bash
./bin/disk_report.sh /var 10
```

## Safety notes

- `ping_sweep.sh` is intentionally rate-limited (default `0.2s` between probes) and capped at 64 hosts per run.
- Keep ping ranges small and only scan networks you own or are authorized to test.
- `backup_dir.sh` writes compressed archives and does not delete originals.
- `rotate_logs.sh` keeps a bounded number of rotated files to avoid unbounded growth.
- `disk_report.sh` reads disk usage only; it does not delete files.


## Best-practice notes

- Scripts use strict mode (`set -euo pipefail`) and validate user input before running system commands.
- Required command dependencies are checked explicitly (`tar`, `python`, `ping`, `df`, `du`) to fail fast with clear errors.
- The test script combines syntax validation (`bash -n`) with behavior checks to catch regressions early.

## Tests

Run local checks:

```bash
./tests/test_cli_tools.sh
```

## CI Pipeline

The GitHub Actions pipeline has 2 stages:
1. ShellCheck linting for all scripts in `bin/` and `tests/`.
2. Test execution via `./tests/test_cli_tools.sh`.

## Repository tree

```text
.
├── .github/workflows/ci.yml      # CI pipeline: ShellCheck + test run
├── bin/
│   ├── backup_dir.sh             # Create timestamped tar.gz directory backups
│   ├── disk_report.sh            # Show df summary + largest directories
│   ├── json_pretty.sh            # Pretty-print JSON using python -m json.tool
│   ├── ping_sweep.sh             # Safe/rate-limited ping sweep for small ranges
│   └── rotate_logs.sh            # Rotate log files into numbered archives
├── tests/
│   └── test_cli_tools.sh         # Syntax + basic execution checks for all tools
└── README.md                     # Documentation, examples, safety notes
```

## Commit message style

Use short, clear commit messages, for example:

```text
add bash toolbox scripts and ci
```
