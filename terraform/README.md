# OnFinance Terraform Infrastructure

## Prerequisites
- Terraform v1.0.0+
- AWS CLI configured
- kubectl installed

## Usage
```bash
cd terraform/environments/dev
terraform init
terraform validate
terraform plan
terraform apply

# Connect to EKS Cluster

Command: aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region $(terraform output -raw region)

# Implementation Steps

## 6. Implementation Steps

1. Create the directory structure and files
2. Implement the networking module
3. Implement the EKS module 
4. Implement the database module
5. Implement the S3 module
6. Configure the root module
7. Set variables for the dev environment
8. Create documentation
9. Commit and push to GitHub
10. Validate your configuration:
   ```bash
   cd terraform/environments/dev
   terraform init
   terraform validate
   terraform plan

This infrastructure provides:

Multi-AZ deployment across 2 availability zones
Auto-scaling EKS cluster with properly configured worker nodes
Private subnets for databases and compute
Public subnets for load balancers
Secure networking with appropriate security groups
Centralized logging with S3 buckets