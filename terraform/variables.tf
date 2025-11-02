# AWS Configuration
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "fashion-analytics"
}

# S3 Configuration
variable "raw_data_bucket_suffix" {
  description = "Suffix for raw data bucket (must be globally unique)"
  type        = string
  default     = "raw-data-esade-2025"
}

variable "processed_data_bucket_suffix" {
  description = "Suffix for processed data bucket"
  type        = string
  default     = "processed-data-esade-2025"
}

variable "frontend_bucket_suffix" {
  description = "Suffix for frontend hosting bucket"
  type        = string
  default     = "frontend-esade-2025"
}

# DynamoDB Configuration
variable "dynamodb_billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

# Cognito Configuration
variable "cognito_user_pool_name" {
  description = "Name for Cognito User Pool"
  type        = string
  default     = "fashion-analytics-users"
}

# Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Fashion-Analytics-Dashboard"
    University  = "ESADE"
    Course      = "Cloud-Solutions"
  }
}
