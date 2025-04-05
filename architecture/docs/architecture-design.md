# OnFinance AI AWS Architecture Design

## Overview
Brief description of the overall solution and objectives.

## Architecture Components

### Compute Platform
- AWS EKS Kubernetes cluster
- EC2 Auto Scaling Groups for worker nodes
- Why we chose EKS over alternatives

### Networking
- VPC with CIDR block 10.0.0.0/16
- 2 Public subnets (10.0.1.0/24, 10.0.2.0/24)
- 2 Private application subnets (10.0.3.0/24, 10.0.4.0/24)
- 2 Private database subnets (10.0.5.0/24, 10.0.6.0/24)
- NAT Gateways for outbound connectivity
- Internet Gateway for inbound traffic
- Application Load Balancer for traffic distribution

### Data Storage
- RDS with Multi-AZ for primary database
- S3 buckets for object storage
- Justification for choices

### Additional Services
- CloudWatch for logging and monitoring
- IAM roles with least privilege for security
- AWS Secrets Manager for credentials
- Amazon Certificate Manager for SSL/TLS

## High Availability & Scalability
- Multi-AZ deployment across 2 availability zones
- Auto-scaling configurations for worker nodes
- RDS Multi-AZ for database failover
- How the system handles increased load

## Security Considerations
- Network segmentation with public/private subnets
- Security group configurations
- IAM role-based access control
- Encryption at rest and in transit

## Data Flow
Step-by-step explanation of how data flows through the system