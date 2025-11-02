# S3 Outputs
output "raw_data_bucket_name" {
  description = "Name of the raw data S3 bucket"
  value       = module.s3.raw_data_bucket_name
}

output "processed_data_bucket_name" {
  description = "Name of the processed data S3 bucket"
  value       = module.s3.processed_data_bucket_name
}

output "frontend_bucket_name" {
  description = "Name of the frontend hosting S3 bucket"
  value       = module.s3.frontend_bucket_name
}

output "frontend_bucket_website_endpoint" {
  description = "Website endpoint for frontend bucket"
  value       = module.s3.frontend_website_endpoint
}

# Cognito Outputs
output "cognito_user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = module.cognito.user_pool_client_id
}

output "cognito_user_pool_domain" {
  description = "Domain of the Cognito User Pool"
  value       = module.cognito.user_pool_domain
}

# DynamoDB Outputs
output "dynamodb_tables" {
  description = "Names of DynamoDB tables"
  value = {
    trends    = module.dynamodb.trends_table_name
    sales     = module.dynamodb.sales_analytics_table_name
    sentiment = module.dynamodb.sentiment_table_name
  }
}
