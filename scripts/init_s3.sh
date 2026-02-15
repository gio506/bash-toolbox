#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
REGION="${AWS_REGION:-us-east-1}"
BUCKET_NAME="${BUCKET_NAME:-demo-bucket}"
SAMPLE_FILE="${SAMPLE_FILE:-data/sample.txt}"

aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" s3 mb "s3://$BUCKET_NAME" || true
aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" s3 cp "$SAMPLE_FILE" "s3://$BUCKET_NAME/sample.txt"
aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" s3 ls "s3://$BUCKET_NAME"

echo "S3 setup complete: bucket=$BUCKET_NAME"
