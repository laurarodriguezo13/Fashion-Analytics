variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "lambda_functions" {
  description = "Map of Lambda function invoke ARNs"
  type = object({
    get_trends_invoke_arn          = string
    get_sales_analytics_invoke_arn = string
    get_sentiment_invoke_arn       = string
    export_data_invoke_arn         = string
    get_trends_function_name          = string
    get_sales_analytics_function_name = string
    get_sentiment_function_name       = string
    export_data_function_name         = string
  })
}

variable "tags" {
  description = "Common tags to apply to API Gateway resources"
  type        = map(string)
  default     = {}
}
