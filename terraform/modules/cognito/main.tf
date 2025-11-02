# Local variables
locals {
  user_pool_name   = "${var.project_name}-${var.environment}-${var.user_pool_name}"
  app_client_name  = "${var.project_name}-${var.environment}-client"
  domain_prefix    = "${var.project_name}-${var.environment}"
}

# =============================================================================
# COGNITO USER POOL
# =============================================================================

resource "aws_cognito_user_pool" "main" {
  name = local.user_pool_name

  # Username/Email configuration
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Password policy
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_uppercase                = true
    require_numbers                  = true
    require_symbols                  = true
    temporary_password_validity_days = 7
  }

  # Email configuration
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Account recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  # User attributes schema
  schema {
    name                = "email"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  schema {
    name                = "name"
    attribute_data_type = "String"
    required            = true
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  # MFA configuration
  mfa_configuration = "OPTIONAL"

  software_token_mfa_configuration {
    enabled = true
  }

  # Admin create user config
  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  # User pool add-ons
  user_pool_add_ons {
    advanced_security_mode = "AUDIT"
  }

  tags = merge(
    var.tags,
    {
      Name        = local.user_pool_name
      Environment = var.environment
    }
  )
}

# =============================================================================
# COGNITO USER POOL CLIENT
# =============================================================================

resource "aws_cognito_user_pool_client" "main" {
  name         = local.app_client_name
  user_pool_id = aws_cognito_user_pool.main.id

  # OAuth flows
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "profile"]

  # Callback URLs (update these later with your actual frontend URL)
  callback_urls = [
    "http://localhost:3000",
    "https://localhost:3000"
  ]

  logout_urls = [
    "http://localhost:3000",
    "https://localhost:3000"
  ]

  # Authentication flows
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Token validity
  refresh_token_validity = 30
  access_token_validity  = 60
  id_token_validity      = 60

  token_validity_units {
    refresh_token = "days"
    access_token  = "minutes"
    id_token      = "minutes"
  }

  # Prevent user existence errors
  prevent_user_existence_errors = "ENABLED"

  # Read/Write attributes
  read_attributes  = ["email", "name", "email_verified"]
  write_attributes = ["email", "name"]
}

# =============================================================================
# COGNITO USER POOL DOMAIN
# =============================================================================

resource "aws_cognito_user_pool_domain" "main" {
  domain       = local.domain_prefix
  user_pool_id = aws_cognito_user_pool.main.id
}

# =============================================================================
# USER GROUPS
# =============================================================================

# Fashion Enthusiasts Group (Read-Only Access)
resource "aws_cognito_user_group" "enthusiasts" {
  name         = "Enthusiasts"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Fashion enthusiasts with read-only access to trends and analytics"
  precedence   = 2
}

# Analysts Group (Full Access)
resource "aws_cognito_user_group" "analysts" {
  name         = "Analysts"
  user_pool_id = aws_cognito_user_pool.main.id
  description  = "Analysts with full access to data, reports, and exports"
  precedence   = 1
}

# =============================================================================
# TEST USERS (Optional - for development)
# =============================================================================

# Test Enthusiast User
resource "aws_cognito_user" "test_enthusiast" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = "enthusiast@test.com"

  attributes = {
    email          = "enthusiast@test.com"
    name           = "Test Enthusiast"
    email_verified = true
  }

  temporary_password = "TempPass123!"

  lifecycle {
    ignore_changes = [
      temporary_password,
      attributes
    ]
  }
}

# Add test enthusiast to Enthusiasts group
resource "aws_cognito_user_in_group" "test_enthusiast_group" {
  user_pool_id = aws_cognito_user_pool.main.id
  group_name   = aws_cognito_user_group.enthusiasts.name
  username     = aws_cognito_user.test_enthusiast.username
}

# Test Analyst User
resource "aws_cognito_user" "test_analyst" {
  user_pool_id = aws_cognito_user_pool.main.id
  username     = "analyst@test.com"

  attributes = {
    email          = "analyst@test.com"
    name           = "Test Analyst"
    email_verified = true
  }

  temporary_password = "TempPass123!"

  lifecycle {
    ignore_changes = [
      temporary_password,
      attributes
    ]
  }
}

# Add test analyst to Analysts group
resource "aws_cognito_user_in_group" "test_analyst_group" {
  user_pool_id = aws_cognito_user_pool.main.id
  group_name   = aws_cognito_user_group.analysts.name
  username     = aws_cognito_user.test_analyst.username
}
