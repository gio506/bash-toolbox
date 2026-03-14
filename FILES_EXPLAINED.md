# Files Explained

## Documentation

- `README.md`
  - Main project guide, usage overview, install notes, and CI summary.
- `CHEATSHEET.md`
  - Fast command reference with copy-paste examples.
- `FILES_EXPLAINED.md`
  - File-by-file explanation for learners and reviewers.

## Scripts

- `bin/backup_dir` and `bin/backup_dir.sh`
  - Create a timestamped `.tar.gz` archive from a source directory.
- `bin/rotate_logs` and `bin/rotate_logs.sh`
  - Keep the newest N `.log` files and remove older ones.
- `bin/json_pretty` and `bin/json_pretty.sh`
  - Validate and pretty-print JSON.
- `bin/ping_sweep` and `bin/ping_sweep.sh`
  - Perform a small and rate-limited ping sweep.
- `bin/disk_report` and `bin/disk_report.sh`
  - Summarize disk usage and large files or directories.
- `lib/common.sh`
  - Shared helper functions for flags, colors, and logging.
- `install.sh`
  - Dry-run-first installer that can symlink the toolbox into `/usr/local/bin`.

## Tests and CI

- `tests/run_tests.sh`
  - Runs syntax checks and safe execution checks for each tool.
- `tests/bats/cli.bats`
  - Bats regression tests for CLI behavior.
- `.github/workflows/ci.yml`
  - Runs structure checks, shell linting, smoke tests, Bats, packaging,
    Markdown linting, and a final status gate.
- `Makefile`
  - Local wrappers for the main validation commands.
