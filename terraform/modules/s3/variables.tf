variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "raw_data_bucket_suffix" {
  description = "Suffix for raw data bucket name"
  type        = string
}

variable "processed_data_bucket_suffix" {
  description = "Suffix for processed data bucket name"
  type        = string
}

variable "frontend_bucket_suffix" {
  description = "Suffix for frontend bucket name"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all S3 resources"
  type        = map(string)
  default     = {}
}
