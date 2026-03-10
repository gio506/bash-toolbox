# bash-toolbox

Small Bash CLI toolbox for day-to-day ops automation, with shared helpers, tests, and CI.

## Repo Map

- `.github/workflows/ci.yml` - CI pipeline for linting, syntax checks, smoke tests, bats, and packaging checks.
- `bin/backup_dir` - Creates timestamped tar.gz backups.
- `bin/rotate_logs` - Keeps only the newest N `.log` files.
- `bin/json_pretty` - Validates and pretty-prints JSON files.
- `bin/ping_sweep` - Rate-limited ping sweep for authorized network ranges.
- `bin/disk_report` - Reports filesystem usage and largest files.
- `lib/common.sh` - Shared logging, color output, and standardized CLI flag parsing.
- `tests/run_tests.sh` - Bash syntax + smoke test runner.
- `tests/bats/cli.bats` - Bats tests for key CLI behavior.
- `install.sh` - Safe-by-default installer (dry-run unless `--yes`).
- `Makefile` - Local developer commands for test and package checks.
- `CHEATSHEET.md` - Fast command reference.
- `FILES_EXPLAINED.md` - One-line explanation per tracked file.

## Standardized CLI flags

All tools support:

- `-h, --help` show usage
- `-q, --quiet` suppress info logs
- `-v, --verbose` debug logs
- `--no-color` disable color output
- `--version` print toolbox version

## Usage examples

```bash
./bin/backup_dir ./data ./backups
./bin/rotate_logs ./logs 3
./bin/json_pretty ./payload.json
./bin/ping_sweep 192.168.1 1 10
./bin/disk_report /var
```

## Install

`install.sh` is safe-by-default and performs a dry-run unless `--yes` is explicitly passed.

```bash
# Review planned symlinks
./install.sh

# Apply symlinks to /usr/local/bin
./install.sh --yes
```

## Tests

```bash
# Full local check
make test
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


## CI pipeline (4 stages)

The GitHub Actions workflow keeps a strict 4-stage gate for PRs from `dev` to `main`:

1. **ShellCheck** (linting)
2. **Bash syntax + smoke tests**
3. **Bats tests**
4. **Packaging check** (tarball build/verify)

It triggers on:

- push to `dev` and `main`
- pull requests targeting `main`

Best-practice notes:

- uses pinned actions for reproducibility
- uses least-privilege permissions (`contents: read`)
- uses concurrency cancellation to avoid duplicate runs on rapid pushes
