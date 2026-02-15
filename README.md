# compose-localstack

A minimal LocalStack setup for **S3 + SQS** with simple shell scripts and a lightweight CI smoke pipeline.

## Prerequisites

- Docker + Docker Compose plugin (`docker compose`)
- AWS CLI v2 (`aws --version`)
- Bash (Linux/macOS or WSL)

## Quick start (step-by-step)

1. Start LocalStack:
   ```bash
   docker compose up -d
   ```
2. Verify LocalStack health:
   ```bash
   curl http://localhost:4566/_localstack/health
   ```
3. Run the end-to-end smoke flow (S3 + SQS):
   ```bash
   ./scripts/smoke.sh
   ```
4. Optional: run scripts one by one:
   ```bash
   ./scripts/init_s3.sh
   ./scripts/init_sqs.sh
   ```
# bash-toolbox

Small Bash utilities for common DevOps tasks.

## Tools in `bin/`

### 1) `backup_dir.sh`
Create a timestamped `.tar.gz` backup of a directory.

```bash
./bin/backup_dir.sh /var/log ./backups
```

### 2) `rotate_logs.sh`
Keep only the newest N `.log` files in a directory.

```bash
./bin/rotate_logs.sh ./logs 3
```

### 3) `json_pretty.sh`
Pretty-print JSON using `python -m json.tool`.

```bash
./bin/json_pretty.sh ./sample.json
```

### 4) `ping_sweep.sh`
Rate-limited ping sweep for a small host range (safe defaults).

```bash
./bin/ping_sweep.sh 192.168.1 1 10
```

### 5) `disk_report.sh`
Show quick disk usage details and top 10 largest items.

```bash
./bin/disk_report.sh /var
```

## Safety notes

- Run these tools only on systems and networks you own or are authorized to test.
- `ping_sweep.sh` is intentionally rate-limited (`sleep 0.2`) and defaults to a small range.
- `rotate_logs.sh` **deletes files** older than the keep threshold; test in a temp directory first.
- `backup_dir.sh` reads source files and writes archives; ensure destination has enough free space.

## Project tree

```text
.
├── .github/workflows/pipeline.yml   # CI: compose up + smoke check
├── data/sample.txt                  # File uploaded to S3 by the script
├── docker-compose.yml               # LocalStack service definition (S3 + SQS)
├── scripts/init_s3.sh               # Creates bucket and uploads sample file
├── scripts/init_sqs.sh              # Creates queue and sends/receives a message
├── scripts/smoke.sh                 # Runs S3 + SQS scripts as a smoke test
├── CHEATSHEET.md                    # Fast command reference for daily usage
└── LOCALSTACK_FREE_SERVICES.md      # What LocalStack is + free tier services list
```

## Useful commands

```bash
# View LocalStack logs
docker compose logs -f localstack

# Stop everything
docker compose down

# Stop + remove LocalStack data
docker compose down -v
├── .github/workflows/ci.yml        # CI pipeline: ShellCheck + tests
├── CHEATSHEET.md                   # Fast command reference for all tools
├── README.md                       # Overview, usage examples, safety notes
├── bin/
│   ├── backup_dir.sh               # Timestamped directory backups (.tar.gz)
│   ├── disk_report.sh              # Filesystem + largest-items report
│   ├── json_pretty.sh              # JSON formatter via python json.tool
│   ├── ping_sweep.sh               # Safe/rate-limited subnet probe
│   └── rotate_logs.sh              # Keep newest N logs, remove older logs
└── tests/
    └── run_tests.sh                # Bash syntax and basic execution checks
```

## Run tests locally

```bash
bash tests/run_tests.sh
```
