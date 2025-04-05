# OnFinance External Data Integration

This directory contains configurations for an ETL pipeline to fetch financial data from external APIs and store it in AWS.

## Architecture

The data integration pipeline follows these steps:
1. Fetch stock market data from Alpha Vantage API
2. Store raw data in S3 for archival purposes
3. Process and transform the data
4. Store processed data in DynamoDB for application use
5. Run daily via AWS Lambda triggered by EventBridge

## Implementation Options

Two implementation approaches are provided:
1. **AWS Lambda + EventBridge** (recommended for production)
2. **Kubernetes CronJob** (alternative approach)

## Prerequisites

### For Lambda Implementation
- AWS account with appropriate permissions
- Alpha Vantage API key (get one at https://www.alphavantage.co/)
- Terraform installed

### For Kubernetes Implementation
- EKS cluster from Stage 2
- Alpha Vantage API key
- kubectl configured to access the cluster

## Deployment Instructions

### Lambda Implementation (using Terraform)

1. Prepare the Lambda deployment package:
   ```bash
   cd data-integration/lambda
   pip install -r requirements.txt -t ./package
   cp stock_data_fetcher.py ./package/
   cd package
   zip -r ../lambda_function.zip .
   cd ..
   mv lambda_function.zip ../terraform/

2. Deploy infrastructure with Terraform:
    cd data-integration/terraform
    terraform init
    terraform apply -var="alpha_vantage_api_key=YOUR_API_KEY"

# Kubernetes Implementation
1. Update the Kubernetes Secret with your API key:
    # First, encode your API key
    echo -n "YOUR_API_KEY" | base64
    # Update the encoded value in data-integration/k8s/secret.yaml
2. Apply the Kubernetes manifests:
    kubectl apply -f data-integration/k8s/secret.yaml
    kubectl apply -f data-integration/k8s/cronjob.yaml

# Verifying the Integration

1. Check CloudWatch Logs:
    aws logs get-log-events --log-group-name /aws/lambda/onfinance_dev_stock_data_fetcher --log-stream-name $(aws logs describe-log-streams --log-group-name /aws/lambda/onfinance_dev_stock_data_fetcher --query 'logStreams[0].logStreamName' --output text)
2. Check S3 for stored data:
    aws s3 ls s3://onfinance-dev-stock-data/stock_data/ --recursive
3. Query DynamoDB for processed data:
    aws dynamodb scan --table-name onfinance_dev_stock_data --limit 5

# Kubernetes Implementation

1. Check CronJob status:
    kubectl get cronjobs
2. Check the most recent job:
    kubectl get jobs
3. Look at pod logs for the most recent job:
    kubectl logs job/stock-data-fetcher-<job-id>

## Implementation Steps

1. Create the data integration directory structure
2. Implement the Lambda function for data fetching
3. Create Terraform infrastructure for Lambda and storage
4. (Optional) Implement Kubernetes CronJob as an alternative approach
5. Create comprehensive documentation
6. Deploy the integration pipeline:
   ```bash
   # For Lambda implementation
   cd data-integration/lambda
   pip install -r requirements.txt -t ./package
   cp stock_data_fetcher.py ./package/
   cd package
   zip -r ../lambda_function.zip .
   cd ..
   mv lambda_function.zip ../terraform/
   cd ../terraform
   terraform init
   terraform apply -var="alpha_vantage_api_key=YOUR_API_KEY"

# Verify the integration:

# Test Lambda manually
aws lambda invoke --function-name onfinance_dev_stock_data_fetcher --payload '{}' output.txt

# Check S3 for data
aws s3 ls s3://onfinance-dev-stock-data/stock_data/ --recursive
