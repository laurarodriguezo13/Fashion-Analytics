variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "user_pool_name" {
  description = "Name for the Cognito User Pool"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to Cognito resources"
  type        = map(string)
  default     = {}
}
