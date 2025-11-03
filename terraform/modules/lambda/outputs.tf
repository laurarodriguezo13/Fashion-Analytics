# GetTrends Function Outputs
output "get_trends_function_name" {
  description = "Name of the GetTrends Lambda function"
  value       = aws_lambda_function.get_trends.function_name
}

output "get_trends_function_arn" {
  description = "ARN of the GetTrends Lambda function"
  value       = aws_lambda_function.get_trends.arn
}

output "get_trends_invoke_arn" {
  description = "Invoke ARN of the GetTrends Lambda function"
  value       = aws_lambda_function.get_trends.invoke_arn
}

# GetSalesAnalytics Function Outputs
output "get_sales_analytics_function_name" {
  description = "Name of the GetSalesAnalytics Lambda function"
  value       = aws_lambda_function.get_sales_analytics.function_name
}

output "get_sales_analytics_function_arn" {
  description = "ARN of the GetSalesAnalytics Lambda function"
  value       = aws_lambda_function.get_sales_analytics.arn
}

output "get_sales_analytics_invoke_arn" {
  description = "Invoke ARN of the GetSalesAnalytics Lambda function"
  value       = aws_lambda_function.get_sales_analytics.invoke_arn
}

# GetSentiment Function Outputs
output "get_sentiment_function_name" {
  description = "Name of the GetSentiment Lambda function"
  value       = aws_lambda_function.get_sentiment.function_name
}

output "get_sentiment_function_arn" {
  description = "ARN of the GetSentiment Lambda function"
  value       = aws_lambda_function.get_sentiment.arn
}

output "get_sentiment_invoke_arn" {
  description = "Invoke ARN of the GetSentiment Lambda function"
  value       = aws_lambda_function.get_sentiment.invoke_arn
}

# ExportData Function Outputs
output "export_data_function_name" {
  description = "Name of the ExportData Lambda function"
  value       = aws_lambda_function.export_data.function_name
}

output "export_data_function_arn" {
  description = "ARN of the ExportData Lambda function"
  value       = aws_lambda_function.export_data.arn
}

output "export_data_invoke_arn" {
  description = "Invoke ARN of the ExportData Lambda function"
  value       = aws_lambda_function.export_data.invoke_arn
}

# All Lambda Functions
output "all_lambda_functions" {
  description = "Map of all Lambda function names"
  value = {
    get_trends          = aws_lambda_function.get_trends.function_name
    get_sales_analytics = aws_lambda_function.get_sales_analytics.function_name
    get_sentiment       = aws_lambda_function.get_sentiment.function_name
    export_data         = aws_lambda_function.export_data.function_name
  }
}
