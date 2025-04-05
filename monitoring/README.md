# OnFinance Monitoring and Logging

This directory contains configurations for implementing comprehensive monitoring and logging for the OnFinance EKS cluster.

## Components

### Centralized Logging
- **Fluent Bit**: Collects container logs from all pods
- **CloudWatch Logs**: Stores logs centrally for analysis and retention

### Metrics Collection
- **Kubernetes Metrics Server**: Collects pod and node metrics
- **CloudWatch Container Insights**: Provides detailed metrics and monitoring

### Alerting
- **CloudWatch Alarms**: Triggers alerts based on metric thresholds
- **SNS Notifications**: Delivers alerts via email

## Deployment Instructions

### Prerequisites
- EKS cluster deployed via Terraform (Stage 2)
- Kubernetes application deployed (Stage 3)
- IAM roles with sufficient permissions for CloudWatch and Fluent Bit

### Deploying the Monitoring Stack

1. Create the CloudWatch namespace:
   kubectl create namespace amazon-cloudwatch
2. Deploy Fluent Bit for log collection:
   kubectl apply -f monitoring/fluent-bit/
3. Deploy metrics server:
   kubectl apply -f monitoring/metrics-server/
4. Deploy CloudWatch agent:
   kubectl apply -f monitoring/cloudwatch/
5. Apply Terraform configuration for CloudWatch alarms:
   cd monitoring/alerts/
   terraform init
   terraform apply

# Verifying the Deployment

1. Verify Fluent Bit is running:
   kubectl get pods -n kube-system | grep fluent-bit
2. Verify metrics server is available:
   kubectl get apiservice v1beta1.metrics.k8s.io
   kubectl top nodes
   kubectl top pods

3. Verify CloudWatch logs:

Check AWS Console > CloudWatch > Log groups > /onfinance/eks/cluster

4. Verify CloudWatch alarms:

Check AWS Console > CloudWatch > Alarms

# Accessing Logs and Metrics

CloudWatch Logs

Navigate to AWS CloudWatch console
Select "Log groups" from the left navigation
Browse logs in the "/onfinance/eks/cluster" log group

# CloudWatch Metrics

1. Navigate to AWS CloudWatch console
2. Select "All metrics" from the left navigation
3. Filter for "ContainerInsights" namespace

## Implementation Steps

1. Create the monitoring directory structure
2. Implement Fluent Bit configurations for log collection
3. Configure Kubernetes metrics server
4. Create CloudWatch alarms and SNS notifications using Terraform
5. Configure CloudWatch Container Insights
6. Create comprehensive documentation
7. Deploy the monitoring stack:
   ```bash
   # Create namespace
   kubectl create namespace amazon-cloudwatch

   # Apply Fluent Bit configurations
   kubectl apply -f monitoring/fluent-bit/

   # Apply metrics server
   kubectl apply -f monitoring/metrics-server/

   # Apply CloudWatch agent
   kubectl apply -f monitoring/cloudwatch/

   # Apply Terraform for alarms
   cd monitoring/alerts/
   terraform init
   terraform apply

# Verify the deployment:

kubectl get pods -n kube-system | grep fluent-bit
kubectl top nodes
kubectl top pods

