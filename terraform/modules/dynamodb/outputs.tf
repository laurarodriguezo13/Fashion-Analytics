# Fashion Trends Table Outputs
output "trends_table_name" {
  description = "Name of the Fashion Trends DynamoDB table"
  value       = aws_dynamodb_table.fashion_trends.name
}

output "trends_table_arn" {
  description = "ARN of the Fashion Trends DynamoDB table"
  value       = aws_dynamodb_table.fashion_trends.arn
}

output "trends_table_stream_arn" {
  description = "Stream ARN of the Fashion Trends table"
  value       = aws_dynamodb_table.fashion_trends.stream_arn
}

# Sales Analytics Table Outputs
output "sales_analytics_table_name" {
  description = "Name of the Sales Analytics DynamoDB table"
  value       = aws_dynamodb_table.sales_analytics.name
}

output "sales_analytics_table_arn" {
  description = "ARN of the Sales Analytics DynamoDB table"
  value       = aws_dynamodb_table.sales_analytics.arn
}

# Brand Sentiment Table Outputs
output "sentiment_table_name" {
  description = "Name of the Brand Sentiment DynamoDB table"
  value       = aws_dynamodb_table.brand_sentiment.name
}

output "sentiment_table_arn" {
  description = "ARN of the Brand Sentiment DynamoDB table"
  value       = aws_dynamodb_table.brand_sentiment.arn
}

# User Preferences Table Outputs
output "user_preferences_table_name" {
  description = "Name of the User Preferences DynamoDB table"
  value       = aws_dynamodb_table.user_preferences.name
}

output "user_preferences_table_arn" {
  description = "ARN of the User Preferences DynamoDB table"
  value       = aws_dynamodb_table.user_preferences.arn
}

# All table names as a map
output "all_table_names" {
  description = "Map of all DynamoDB table names"
  value = {
    trends           = aws_dynamodb_table.fashion_trends.name
    sales_analytics  = aws_dynamodb_table.sales_analytics.name
    sentiment        = aws_dynamodb_table.brand_sentiment.name
    user_preferences = aws_dynamodb_table.user_preferences.name
  }
}
