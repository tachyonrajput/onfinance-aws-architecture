# terraform/environments/dev/main.tf
module "networking" {
  source = "../../modules/networking"
  region = var.region
  project_name = var.project_name
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "eks" {
  source = "../../modules/eks"
  project_name = var.project_name
  environment = var.environment
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  # Additional parameters...
}

module "database" {
  source = "../../modules/database"
  # Parameters...
}

module "logs_bucket" {
  source = "../../modules/s3"
  project_name = var.project_name
  environment = var.environment
  bucket_name = "logs"
}