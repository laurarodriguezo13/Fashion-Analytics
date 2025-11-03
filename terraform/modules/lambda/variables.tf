variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "dynamodb_tables" {
  description = "Map of DynamoDB table names"
  type = object({
    trends           = string
    sales_analytics  = string
    sentiment        = string
    user_preferences = string
  })
}

variable "tags" {
  description = "Common tags to apply to Lambda resources"
  type        = map(string)
  default     = {}
}
