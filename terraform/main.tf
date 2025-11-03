# Fashion Analytics Dashboard - Main Terraform Configuration

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

# Lambda Functions Module
module "lambda" {
  source = "./modules/lambda"
  
  project_name = var.project_name
  environment  = var.environment
  
  dynamodb_tables = module.dynamodb.all_table_names
  
  tags = local.common_tags
}

# API Gateway Module
module "api_gateway" {
  source = "./modules/api-gateway"
  
  project_name = var.project_name
  environment  = var.environment
  
  lambda_functions = {
    get_trends_invoke_arn          = module.lambda.get_trends_invoke_arn
    get_sales_analytics_invoke_arn = module.lambda.get_sales_analytics_invoke_arn
    get_sentiment_invoke_arn       = module.lambda.get_sentiment_invoke_arn
    export_data_invoke_arn         = module.lambda.export_data_invoke_arn
    get_trends_function_name          = module.lambda.get_trends_function_name
    get_sales_analytics_function_name = module.lambda.get_sales_analytics_function_name
    get_sentiment_function_name       = module.lambda.get_sentiment_function_name
    export_data_function_name         = module.lambda.export_data_function_name
  }
  
  tags = local.common_tags
}
