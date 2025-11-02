# Fashion Analytics Dashboard - Main Terraform Configuration
# AWS Academy Learner Lab Deployment

# Local variables for resource naming
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = merge(
    var.common_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# S3 Buckets Module
module "s3" {
  source = "./modules/s3"
  
  project_name                 = var.project_name
  environment                  = var.environment
  raw_data_bucket_suffix       = var.raw_data_bucket_suffix
  processed_data_bucket_suffix = var.processed_data_bucket_suffix
  frontend_bucket_suffix       = var.frontend_bucket_suffix
  
  tags = local.common_tags
}

# Cognito Authentication Module
module "cognito" {
  source = "./modules/cognito"
  
  project_name   = var.project_name
  environment    = var.environment
  user_pool_name = var.cognito_user_pool_name
  
  tags = local.common_tags
}

# DynamoDB Tables Module
module "dynamodb" {
  source = "./modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
  billing_mode = var.dynamodb_billing_mode
  
  tags = local.common_tags
}

# Lambda Functions Module (coming next)
# module "lambda" {
#   source = "./modules/lambda"
#   ...
# }

# API Gateway Module (coming next)
# module "api_gateway" {
#   source = "./modules/api-gateway"
#   ...
# }
