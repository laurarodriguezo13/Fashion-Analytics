# Local variables
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# FASHION TRENDS TABLE
# =============================================================================

resource "aws_dynamodb_table" "fashion_trends" {
  name           = "${local.name_prefix}-trends"
  billing_mode   = var.billing_mode
  hash_key       = "category"
  range_key      = "date"

  # Attributes (only define keys and GSI keys)
  attribute {
    name = "category"
    type = "S"  # String
  }

  attribute {
    name = "date"
    type = "S"  # String (ISO date format: 2025-01-20)
  }

  attribute {
    name = "popularity_score"
    type = "N"  # Number
  }

  # Global Secondary Index for querying by popularity
  global_secondary_index {
    name            = "PopularityIndex"
    hash_key        = "category"
    range_key       = "popularity_score"
    projection_type = "ALL"
  }

  # Point-in-time recovery (backup)
  point_in_time_recovery {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption {
    enabled = true
  }

  # TTL (Time To Live) - optional
  ttl {
    enabled        = false
    attribute_name = "ttl"
  }

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-trends"
      Purpose     = "Store fashion trend analytics"
      Environment = var.environment
    }
  )
}

# =============================================================================
# SALES ANALYTICS TABLE
# =============================================================================

resource "aws_dynamodb_table" "sales_analytics" {
  name           = "${local.name_prefix}-sales-analytics"
  billing_mode   = var.billing_mode
  hash_key       = "brand"
  range_key      = "month"

  attribute {
    name = "brand"
    type = "S"
  }

  attribute {
    name = "month"
    type = "S"  # Format: 2025-01
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-sales-analytics"
      Purpose     = "Store sales performance metrics by brand"
      Environment = var.environment
    }
  )
}

# =============================================================================
# BRAND SENTIMENT TABLE
# =============================================================================

resource "aws_dynamodb_table" "brand_sentiment" {
  name           = "${local.name_prefix}-sentiment"
  billing_mode   = var.billing_mode
  hash_key       = "brand"
  range_key      = "date"

  attribute {
    name = "brand"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"  # ISO date format: 2025-01-20
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-sentiment"
      Purpose     = "Store brand sentiment analysis from social media"
      Environment = var.environment
    }
  )
}

# =============================================================================
# USER PREFERENCES TABLE (Optional - for personalization)
# =============================================================================

resource "aws_dynamodb_table" "user_preferences" {
  name           = "${local.name_prefix}-user-preferences"
  billing_mode   = var.billing_mode
  hash_key       = "user_id"

  attribute {
    name = "user_id"
    type = "S"  # Cognito User ID
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name        = "${local.name_prefix}-user-preferences"
      Purpose     = "Store user preferences and saved items"
      Environment = var.environment
    }
  )
}
