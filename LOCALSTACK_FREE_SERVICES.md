# What is LocalStack?

LocalStack is a local AWS cloud emulator that lets you build and test AWS workflows on your machine without deploying to real AWS.

## Why use it

- Faster feedback loops for development
- Lower cost for local testing
- Better offline development support
- Easier CI smoke tests for cloud-based scripts

## What you can build with LocalStack free/community

In the free/community edition, you can usually build and test many day-to-day cloud development tasks, for example:

- **Storage flows**: create S3 buckets, upload/download objects, list objects.
- **Messaging flows**: create SQS queues, send/receive/delete messages.
- **Event-driven prototypes**: wire SNS/SQS and EventBridge-style event routing for local tests.
- **Serverless basics**: package and invoke Lambda functions locally for integration checks.
- **NoSQL testing**: design and validate DynamoDB table/item CRUD behavior.
- **Secrets/config simulation**: store local parameters/secrets via SSM/Secrets Manager APIs.
- **CI smoke tests**: run cloud-like integration checks on pull requests before real AWS deploy.

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

> Notes:
> - Service depth differs by service; some advanced features may require paid tiers.
> - Coverage can vary by LocalStack version. Check official docs for the most current matrix.
