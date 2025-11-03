# Local variables
locals {
  function_name_prefix = "${var.project_name}-${var.environment}"
  
  # Use AWS Academy's pre-existing LabRole
  # In AWS Academy, we can't create IAM roles, so we use the provided LabRole
  lab_role_arn = "arn:aws:iam::575020417394:role/LabRole"
}

# =============================================================================
# NOTE: Using AWS Academy LabRole
# =============================================================================
# In AWS Academy Learner Lab, we cannot create IAM roles due to permission restrictions.
# Instead, we use the pre-configured LabRole which has all necessary permissions
# for Lambda, DynamoDB, S3, CloudWatch Logs, etc.

# =============================================================================
# LAMBDA FUNCTION: GET TRENDS
# =============================================================================

# Package Lambda function code
data "archive_file" "get_trends" {
  type        = "zip"
  source_file = "${path.root}/../lambda-functions/get-trends/index.py"
  output_path = "${path.root}/../lambda-functions/get-trends/function.zip"
}

resource "aws_lambda_function" "get_trends" {
  filename         = data.archive_file.get_trends.output_path
  function_name    = "${local.function_name_prefix}-get-trends"
  role            = local.lab_role_arn
  handler         = "index.lambda_handler"
  source_code_hash = data.archive_file.get_trends.output_base64sha256
  runtime         = "python3.12"
  timeout         = 30
  memory_size     = 256

  environment {
    variables = {
      TRENDS_TABLE = var.dynamodb_tables.trends
      ENVIRONMENT  = var.environment
    }
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name_prefix}-get-trends"
      Function = "Query fashion trends data"
    }
  )
}

# CloudWatch Log Group for GetTrends
resource "aws_cloudwatch_log_group" "get_trends" {
  name              = "/aws/lambda/${aws_lambda_function.get_trends.function_name}"
  retention_in_days = 7

  tags = var.tags
}

# =============================================================================
# LAMBDA FUNCTION: GET SALES ANALYTICS
# =============================================================================

data "archive_file" "get_sales_analytics" {
  type        = "zip"
  source_file = "${path.root}/../lambda-functions/get-sales-analytics/index.py"
  output_path = "${path.root}/../lambda-functions/get-sales-analytics/function.zip"
}

resource "aws_lambda_function" "get_sales_analytics" {
  filename         = data.archive_file.get_sales_analytics.output_path
  function_name    = "${local.function_name_prefix}-get-sales-analytics"
  role            = local.lab_role_arn
  handler         = "index.lambda_handler"
  source_code_hash = data.archive_file.get_sales_analytics.output_base64sha256
  runtime         = "python3.12"
  timeout         = 30
  memory_size     = 256

  environment {
    variables = {
      SALES_TABLE = var.dynamodb_tables.sales_analytics
      ENVIRONMENT = var.environment
    }
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name_prefix}-get-sales-analytics"
      Function = "Query sales analytics data"
    }
  )
}

resource "aws_cloudwatch_log_group" "get_sales_analytics" {
  name              = "/aws/lambda/${aws_lambda_function.get_sales_analytics.function_name}"
  retention_in_days = 7

  tags = var.tags
}

# =============================================================================
# LAMBDA FUNCTION: GET SENTIMENT
# =============================================================================

data "archive_file" "get_sentiment" {
  type        = "zip"
  source_file = "${path.root}/../lambda-functions/get-sentiment/index.py"
  output_path = "${path.root}/../lambda-functions/get-sentiment/function.zip"
}

resource "aws_lambda_function" "get_sentiment" {
  filename         = data.archive_file.get_sentiment.output_path
  function_name    = "${local.function_name_prefix}-get-sentiment"
  role            = local.lab_role_arn
  handler         = "index.lambda_handler"
  source_code_hash = data.archive_file.get_sentiment.output_base64sha256
  runtime         = "python3.12"
  timeout         = 30
  memory_size     = 256

  environment {
    variables = {
      SENTIMENT_TABLE = var.dynamodb_tables.sentiment
      ENVIRONMENT     = var.environment
    }
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name_prefix}-get-sentiment"
      Function = "Query brand sentiment data"
    }
  )
}

resource "aws_cloudwatch_log_group" "get_sentiment" {
  name              = "/aws/lambda/${aws_lambda_function.get_sentiment.function_name}"
  retention_in_days = 7

  tags = var.tags
}

# =============================================================================
# LAMBDA FUNCTION: EXPORT DATA
# =============================================================================

data "archive_file" "export_data" {
  type        = "zip"
  source_file = "${path.root}/../lambda-functions/export-data/index.py"
  output_path = "${path.root}/../lambda-functions/export-data/function.zip"
}

resource "aws_lambda_function" "export_data" {
  filename         = data.archive_file.export_data.output_path
  function_name    = "${local.function_name_prefix}-export-data"
  role            = local.lab_role_arn
  handler         = "index.lambda_handler"
  source_code_hash = data.archive_file.export_data.output_base64sha256
  runtime         = "python3.12"
  timeout         = 60
  memory_size     = 512

  environment {
    variables = {
      TRENDS_TABLE     = var.dynamodb_tables.trends
      SALES_TABLE      = var.dynamodb_tables.sales_analytics
      SENTIMENT_TABLE  = var.dynamodb_tables.sentiment
      ENVIRONMENT      = var.environment
    }
  }

  tags = merge(
    var.tags,
    {
      Name     = "${local.function_name_prefix}-export-data"
      Function = "Export data to CSV format"
    }
  )
}

resource "aws_cloudwatch_log_group" "export_data" {
  name              = "/aws/lambda/${aws_lambda_function.export_data.function_name}"
  retention_in_days = 7

  tags = var.tags
}
