# bash-toolbox — Real World Usage Notes

Personal notes on when and where I actually use each tool in this toolbox.

---

## sys-health

**Used when**: Onboarding a new server or debugging unexplained slowdowns.

```bash
# Full health check on remote server
ssh user@server "bash -s" < bin/sys-health

# Compare output from multiple servers quickly
for host in web1 web2 db1; do
  echo "=== $host ==="
  ssh "$host" "bash -s" < bin/sys-health 2>/dev/null
done
```

**What it tells me quickly**:
- Load average vs CPU count (rule of thumb: load > 2× CPUs = problem)
- Free memory (Linux caches aggressively — look at `available`, not `free`)
- Disk usage (> 85% on `/` = act now)
- Open file descriptors (high = leaky app or too many connections)

---

## disk-check

**Used when**: Got an alert that a disk is filling up and need to find what's using it.

```bash
# Find the top 20 largest directories
bin/disk-check /var

# Common culprits:
# /var/log/        — logs not rotating
# /var/lib/docker/ — unused images/volumes
# /tmp/            — large temp files left by crashed jobs
```

**Quick wins if disk is full**:

```bash
# Clean Docker
docker system prune -f

# Rotate logs immediately
logrotate -f /etc/logrotate.conf

# Find files > 100MB modified in last 7 days
find /var -mtime -7 -size +100M -type f 2>/dev/null
```

---

## git-summary

**Used when**: Joining a project and need to quickly understand recent activity.

```bash
# Last 30 days of git activity on a project
cd /path/to/project
bin/git-summary

# Who's been committing most recently
git shortlog -s -n --since="30 days ago"
```

---

## port-check

**Used when**: Debugging connectivity issues or verifying a service is listening.

```bash
# Is nginx listening?
bin/port-check 80 443

# Check if database port is reachable from app server
ssh app-server "bash -s" < bin/port-check <<< "5432"
```

---

## Why Bats for Testing?

I started with pure bash assertion scripts, but Bats makes tests readable and produces proper output:

```
1..5
ok 1 - disk-check exits 0 when disk exists
ok 2 - disk-check outputs human-readable sizes
not ok 3 - disk-check fails on non-existent path
  ---
  message: Expected exit code 1, got 0
  ---
```

This format works with most CI systems (JUnit XML output available with `bats --formatter junit`).

---

## Bash Patterns I Reuse

```bash
# Safe-fail default (exit on unset vars, fail on pipe errors)
set -euo pipefail

# Temp dir that cleans up automatically
TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

# Color output in terminals
RED='\033[0;31m'; GREEN='\033[0;32m'; RESET='\033[0m'
echo -e "${GREEN}PASS${RESET}: test description"

# Check if command exists before using it
command -v docker &>/dev/null || { echo "docker not found"; exit 1; }
```
