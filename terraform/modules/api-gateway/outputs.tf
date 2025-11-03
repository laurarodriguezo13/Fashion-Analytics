# API Gateway Outputs
output "api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.main.id
}

output "api_arn" {
  description = "ARN of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.main.arn
}

output "api_endpoint" {
  description = "Base URL for API Gateway stage"
  value       = aws_api_gateway_stage.main.invoke_url
}

output "api_stage_name" {
  description = "Name of the API Gateway stage"
  value       = aws_api_gateway_stage.main.stage_name
}

# Individual Endpoint URLs
output "endpoints" {
  description = "Map of all API endpoints"
  value = {
    trends          = "${aws_api_gateway_stage.main.invoke_url}/trends"
    sales_analytics = "${aws_api_gateway_stage.main.invoke_url}/sales-analytics"
    sentiment       = "${aws_api_gateway_stage.main.invoke_url}/sentiment"
    export          = "${aws_api_gateway_stage.main.invoke_url}/export"
  }
}
