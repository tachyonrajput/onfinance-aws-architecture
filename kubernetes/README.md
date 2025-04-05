# OnFinance Kubernetes Deployment

This directory contains Kubernetes manifests for deploying the OnFinance application to AWS EKS.

## Project Structure

kubernetes/
├── manifests/
│   ├── backend/           # Backend API service
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── hpa.yaml
│   ├── frontend/          # Frontend web service
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── hpa.yaml
│   ├── config/            # Configuration
│   │   ├── configmap.yaml
│   │   └── secret.yaml
│   └── network/           # Network configuration
│       └── ingress.yaml
└── README.md              # This file

## Application Components

### Backend API Service
- Stateless API service
- Multiple replicas for high availability
- Horizontal Pod Autoscaler for automatic scaling
- Health checks via liveness and readiness probes
- Secure database credentials via Kubernetes Secrets

### Frontend Web Service
- User-facing web interface
- Exposed via LoadBalancer for public access
- Auto-scaling based on CPU utilization
- Configuration via ConfigMaps

## Deployment Features

### High Availability
- Multiple replicas of each service
- Deployment across multiple Availability Zones
- Self-healing through Kubernetes health checks

### Scalability
- Horizontal Pod Autoscalers for both frontend and backend
- Resource requests and limits properly configured

### Configuration Management
- Environment variables via ConfigMaps
- Sensitive data via Kubernetes Secrets
- Clear separation of code and configuration

## Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- kubectl installed and configured to access the EKS cluster
- EKS cluster provisioned via Terraform (Stage 2)

### Deploy the Application

1. Connect to the EKS cluster:
   ```bash
   aws eks update-kubeconfig --name onfinance-eks --region us-east-1

2. Apply the configuration resources first:
    kubectl apply -f kubernetes/manifests/config/
3. Deploy the backend services:
    kubectl apply -f kubernetes/manifests/backend/
4. Deploy the frontend services:
    kubectl apply -f kubernetes/manifests/frontend/
5. Apply the network ingress:
    kubectl apply -f kubernetes/manifests/network/

# Verify the deployments

1. Check pod status:
   kubectl get pods
2. Check services:
   kubectl get services
3. Check Horizontal Pod Autoscalers:
   kubectl get hpa
4. Access the frontend web service:
   kubectl get service frontend-web -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# Debugging
If pods are not starting correctly:

kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl describe configmap app-config
kubectl describe secret app-secrets