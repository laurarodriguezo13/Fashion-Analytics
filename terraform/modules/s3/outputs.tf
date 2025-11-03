# Bucket Names
output "raw_data_bucket_name" {
  description = "Name of the raw data bucket"
  value       = aws_s3_bucket.raw_data.id
}

output "raw_data_bucket_arn" {
  description = "ARN of the raw data bucket"
  value       = aws_s3_bucket.raw_data.arn
}

output "processed_data_bucket_name" {
  description = "Name of the processed data bucket"
  value       = aws_s3_bucket.processed_data.id
}

output "processed_data_bucket_arn" {
  description = "ARN of the processed data bucket"
  value       = aws_s3_bucket.processed_data.arn
}

output "frontend_bucket_name" {
  description = "Name of the frontend bucket"
  value       = aws_s3_bucket.frontend.id
}

output "frontend_bucket_arn" {
  description = "ARN of the frontend bucket"
  value       = aws_s3_bucket.frontend.arn
}

# Website Endpoints
output "frontend_website_endpoint" {
  description = "Website endpoint URL for frontend bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "frontend_website_domain" {
  description = "Website domain for frontend bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_domain
}

# Bucket Regional Domain Names (for CloudFront)
output "frontend_bucket_regional_domain_name" {
  description = "Regional domain name of the frontend bucket"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}
