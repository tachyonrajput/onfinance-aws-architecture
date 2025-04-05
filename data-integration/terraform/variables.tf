# data-integration/terraform/variables.tf
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name to be used for resource naming"
  type        = string
  default     = "onfinance"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "alpha_vantage_api_key" {
  description = "API key for Alpha Vantage"
  type        = string
  sensitive   = true
}

variable "stock_symbols" {
  description = "Comma-separated list of stock symbols to fetch"
  type        = string
  default     = "AAPL,MSFT,AMZN,GOOGL,META"
}