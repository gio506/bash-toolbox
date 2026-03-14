# bash-toolbox

Small Bash CLI toolbox for day-to-day ops automation, with shared helpers,
tests, and CI.

This repo is also useful as a Junior+ Bash practice lab for:

- argument parsing and usage validation
- defensive Bash with `set -euo pipefail`
- safe file handling and small automation helpers
- repeatable shell testing with smoke tests and Bats

## Quick start

```bash
git clone https://github.com/<your-username>/bash-toolbox.git
cd bash-toolbox
chmod +x bin/* tests/*.sh install.sh
bash tests/run_tests.sh
```

## Repo Map

- `.github/workflows/ci.yml` - CI pipeline for structure checks, shell linting,
  smoke tests, Bats, packaging, docs lint, and final gate.
- `bin/backup_dir` and `bin/backup_dir.sh` - Create timestamped tar.gz backups.
- `bin/rotate_logs` and `bin/rotate_logs.sh` - Keep only the newest N `.log` files.
- `bin/json_pretty` and `bin/json_pretty.sh` - Validate and pretty-print JSON files.
- `bin/ping_sweep` and `bin/ping_sweep.sh` - Rate-limited ping sweep for authorized ranges.
- `bin/disk_report` and `bin/disk_report.sh` - Report filesystem usage and largest files.
- `lib/common.sh` - Shared logging, color output, and standardized CLI flag parsing.
- `tests/run_tests.sh` - Bash syntax + smoke test runner.
- `tests/bats/cli.bats` - Bats tests for key CLI behavior.
- `install.sh` - Safe-by-default installer (dry-run unless `--yes`).
- `Makefile` - Local developer commands for test and package checks.
- `CHEATSHEET.md` - Fast command reference.
- `FILES_EXPLAINED.md` - One-line explanation per tracked file.

## Standardized CLI flags

All primary tools support:

- `-h, --help`
- `-q, --quiet`
- `-v, --verbose`
- `--no-color`
- `--version`

## Usage examples

```bash
./bin/backup_dir ./data ./backups
./bin/rotate_logs ./logs 3
./bin/json_pretty ./payload.json
./bin/ping_sweep 192.168.1 1 10
./bin/disk_report /var
```

## Install

`install.sh` is safe-by-default and performs a dry-run unless `--yes` is passed.

```bash
./install.sh
./install.sh --yes
```

## Local validation

```bash
make test
shellcheck bin/* lib/*.sh tests/run_tests.sh
```

If `bats` is missing locally:

```bash
sudo apt-get install -y bats
```

## Safety notes

- Run `ping_sweep` only on networks you own or are explicitly authorized to assess.
- `rotate_logs` permanently deletes older files beyond your keep count.
- `backup_dir` can consume significant disk space; verify destination capacity first.
- Review scripts before running `install.sh --yes` with elevated privileges.

## CI pipeline

The workflow keeps these stages separate:

1. `structure-check`
2. `shellcheck`
3. `syntax-and-smoke`
4. `bats`
5. `package-check`
6. `markdown-lint`
7. `final-status-gate`

This keeps shell failures, runtime failures, packaging issues, and docs issues easy to debug.
