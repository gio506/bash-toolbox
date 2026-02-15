# Quick Cheatsheet

## What each file is for

- `docker-compose.yml`: runs LocalStack with only S3 and SQS.
- `scripts/init_s3.sh`: creates a bucket and uploads `data/sample.txt`.
- `scripts/init_sqs.sh`: creates a queue, sends a message, then receives it.
- `scripts/smoke.sh`: runs both setup scripts for a quick validation.
- `.github/workflows/pipeline.yml`: CI smoke pipeline.

## Most-used commands

```bash
# Start LocalStack
docker compose up -d

# Run full smoke test
./scripts/smoke.sh

# Stop LocalStack
docker compose down
```
