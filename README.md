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
```
