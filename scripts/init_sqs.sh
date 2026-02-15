#!/usr/bin/env bash
set -euo pipefail

ENDPOINT_URL="${ENDPOINT_URL:-http://localhost:4566}"
REGION="${AWS_REGION:-us-east-1}"
QUEUE_NAME="${QUEUE_NAME:-demo-queue}"
MESSAGE_BODY="${MESSAGE_BODY:-hello-from-localstack}"

QUEUE_URL=$(aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" sqs create-queue \
  --queue-name "$QUEUE_NAME" \
  --query 'QueueUrl' --output text)

aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" sqs send-message \
  --queue-url "$QUEUE_URL" \
  --message-body "$MESSAGE_BODY" >/dev/null

aws --endpoint-url "$ENDPOINT_URL" --region "$REGION" sqs receive-message \
  --queue-url "$QUEUE_URL" \
  --max-number-of-messages 1 \
  --wait-time-seconds 1

echo "SQS setup complete: queue=$QUEUE_NAME"
