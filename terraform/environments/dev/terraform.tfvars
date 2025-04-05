# terraform/environments/dev/terraform.tfvars
region = "us-east-1"
project_name = "onfinance"
environment = "dev"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
kubernetes_version = "1.27"
node_desired_size = 2
node_max_size = 4
node_min_size = 2