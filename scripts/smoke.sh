#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export ENDPOINT_URL AWS_REGION AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: aws CLI is required in PATH for smoke tests."
  exit 1
fi

./scripts/init_s3.sh
./scripts/init_sqs.sh

echo "Smoke test passed."
