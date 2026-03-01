# Variables for AZ-500 Security Project
# These can be overridden via terraform.tfvars or command line

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "az500-security"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    project     = "az500-security"
    environment = "dev"
    managed_by  = "terraform"
    owner       = "security-team"
  }
}

# Network Configuration
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_subnet_address_prefix" {
  description = "Address prefix for application subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "data_subnet_address_prefix" {
  description = "Address prefix for data subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}
