# User Pool Outputs
output "user_pool_id" {
  description = "ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_arn" {
  description = "ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.arn
}

output "user_pool_endpoint" {
  description = "Endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.main.endpoint
}

# User Pool Client Outputs
output "user_pool_client_id" {
  description = "ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.main.id
}

output "user_pool_client_secret" {
  description = "Secret of the Cognito User Pool Client (if generated)"
  value       = aws_cognito_user_pool_client.main.client_secret
  sensitive   = true
}

# Domain Outputs
output "user_pool_domain" {
  description = "Domain prefix for the Cognito User Pool"
  value       = aws_cognito_user_pool_domain.main.domain
}

output "user_pool_domain_cloudfront" {
  description = "CloudFront distribution for Cognito hosted UI"
  value       = aws_cognito_user_pool_domain.main.cloudfront_distribution
}

# Group Outputs
output "enthusiasts_group_name" {
  description = "Name of the Enthusiasts user group"
  value       = aws_cognito_user_group.enthusiasts.name
}

output "analysts_group_name" {
  description = "Name of the Analysts user group"
  value       = aws_cognito_user_group.analysts.name
}

# Test User Outputs
output "test_users" {
  description = "Test user credentials for development"
  value = {
    enthusiast = {
      username = aws_cognito_user.test_enthusiast.username
      password = "TempPass123! (change on first login)"
    }
    analyst = {
      username = aws_cognito_user.test_analyst.username
      password = "TempPass123! (change on first login)"
    }
  }
}
