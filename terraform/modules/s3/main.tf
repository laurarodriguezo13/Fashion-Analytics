# Local variables for bucket naming
locals {
  raw_data_bucket_name       = "${var.project_name}-${var.raw_data_bucket_suffix}"
  processed_data_bucket_name = "${var.project_name}-${var.processed_data_bucket_suffix}"
  frontend_bucket_name       = "${var.project_name}-${var.frontend_bucket_suffix}"
}

# =============================================================================
# RAW DATA BUCKET (Private - for uploading raw datasets)
# =============================================================================

resource "aws_s3_bucket" "raw_data" {
  bucket = local.raw_data_bucket_name

  tags = merge(
    var.tags,
    {
      Name        = local.raw_data_bucket_name
      Purpose     = "Raw fashion data storage"
      DataType    = "Raw"
      Environment = var.environment
    }
  )
}

# Block public access for raw data bucket
resource "aws_s3_bucket_public_access_block" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for raw data bucket
resource "aws_s3_bucket_versioning" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle policy for raw data bucket
resource "aws_s3_bucket_lifecycle_configuration" "raw_data" {
  bucket = aws_s3_bucket.raw_data.id

  rule {
    id     = "archive-old-data"
    status = "Enabled"

    filter {}  # Apply to all objects

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# =============================================================================
# PROCESSED DATA BUCKET (Private - for cleaned/transformed data)
# =============================================================================

resource "aws_s3_bucket" "processed_data" {
  bucket = local.processed_data_bucket_name

  tags = merge(
    var.tags,
    {
      Name        = local.processed_data_bucket_name
      Purpose     = "Processed fashion analytics data"
      DataType    = "Processed"
      Environment = var.environment
    }
  )
}

# Block public access for processed data bucket
resource "aws_s3_bucket_public_access_block" "processed_data" {
  bucket = aws_s3_bucket.processed_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for processed data bucket
resource "aws_s3_bucket_versioning" "processed_data" {
  bucket = aws_s3_bucket.processed_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# =============================================================================
# FRONTEND BUCKET (Public - for React app hosting)
# =============================================================================

resource "aws_s3_bucket" "frontend" {
  bucket = local.frontend_bucket_name

  tags = merge(
    var.tags,
    {
      Name        = local.frontend_bucket_name
      Purpose     = "Frontend React application hosting"
      DataType    = "Frontend"
      Environment = var.environment
    }
  )
}

# Configure static website hosting
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"  # For React Router support
  }
}

# Public access block settings for frontend - MUST BE DISABLED FIRST
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false  # This MUST be false before applying policy
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket policy for public read access - DEPENDS ON PUBLIC ACCESS BLOCK
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  # CRITICAL: Wait for public access block to be configured
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}

# =============================================================================
# FOLDER STRUCTURE IN RAW DATA BUCKET
# =============================================================================

# Create folder structure by uploading placeholder files
resource "aws_s3_object" "raw_data_folders" {
  for_each = toset([
    "kaggle/.placeholder",
    "sec-filings/.placeholder",
    "social-media/.placeholder",
    "trends/.placeholder"
  ])

  bucket  = aws_s3_bucket.raw_data.id
  key     = each.value
  content = "This folder is managed by Terraform"
  
  tags = var.tags
}
