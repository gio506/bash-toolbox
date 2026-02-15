# What is LocalStack?

LocalStack is a local AWS cloud emulator that lets you run and test cloud workflows on your machine without deploying to real AWS.

## Why use it

- Faster feedback loops for development
- Lower cost for local testing
- Better offline development support
- Easier CI smoke tests for cloud-based scripts

## Mini cheatsheet

```bash
# Start emulator
docker compose up -d

# Run project smoke flow
./scripts/smoke.sh

# Check health
curl http://localhost:4566/_localstack/health
```

## Common services available in LocalStack Community (free)

The community edition commonly includes support for many core services, such as:

- API Gateway
- CloudWatch (basic)
- DynamoDB
- EventBridge (CloudWatch Events)
- IAM (basic)
- Kinesis
- Lambda
- S3
- Secrets Manager
- SNS
- SQS
- SSM (Parameter Store)
- STS

> Note: Service coverage can vary by LocalStack version. Check official docs for the most current matrix.
