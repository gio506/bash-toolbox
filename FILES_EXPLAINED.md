# FILES_EXPLAINED

- `.github/workflows/ci.yml` - GitHub Actions workflow used for PR and push checks.
- `bin/backup_dir` - CLI that archives a source directory with a timestamped filename.
- `bin/rotate_logs` - CLI that prunes old log files while keeping newest N files.
- `bin/json_pretty` - CLI that formats JSON through Python's standard json tool.
- `bin/ping_sweep` - CLI that pings a host range with built-in rate limiting.
- `bin/disk_report` - CLI that prints filesystem and top-size item summaries.
- `lib/common.sh` - Shared helper library for logs, colors, and common flags.
- `tests/run_tests.sh` - Portable smoke tests and syntax checks.
- `tests/bats/cli.bats` - Bats regression tests for CLI behavior.
- `install.sh` - Dry-run-first symlink installer for `/usr/local/bin`.
- `Makefile` - Convenient wrappers for lint, test, and package checks.
- `README.md` - Primary project documentation and examples.
- `CHEATSHEET.md` - Fast command index and usage snippets.
- `FILES_EXPLAINED.md` - This file; explains each file in the repository.
