# Local variables
locals {
  api_name = "${var.project_name}-${var.environment}-api"
}

# =============================================================================
# REST API
# =============================================================================

resource "aws_api_gateway_rest_api" "main" {
  name        = local.api_name
  description = "Fashion Analytics Dashboard REST API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = merge(
    var.tags,
    {
      Name = local.api_name
    }
  )
}

# =============================================================================
# API RESOURCES (URL PATHS)
# =============================================================================

# /trends
resource "aws_api_gateway_resource" "trends" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "trends"
}

# /sales-analytics
resource "aws_api_gateway_resource" "sales_analytics" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "sales-analytics"
}

# /sentiment
resource "aws_api_gateway_resource" "sentiment" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "sentiment"
}

# /export
resource "aws_api_gateway_resource" "export" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "export"
}

# =============================================================================
# GET METHOD: /trends
# =============================================================================

resource "aws_api_gateway_method" "trends_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.trends.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.category" = false
    "method.request.querystring.limit"    = false
  }
}

resource "aws_api_gateway_integration" "trends_get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.trends.id
  http_method             = aws_api_gateway_method.trends_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_functions.get_trends_invoke_arn
}

resource "aws_lambda_permission" "trends_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_functions.get_trends_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# =============================================================================
# GET METHOD: /sales-analytics
# =============================================================================

resource "aws_api_gateway_method" "sales_analytics_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.sales_analytics.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.brand" = false
    "method.request.querystring.limit" = false
  }
}

resource "aws_api_gateway_integration" "sales_analytics_get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.sales_analytics.id
  http_method             = aws_api_gateway_method.sales_analytics_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_functions.get_sales_analytics_invoke_arn
}

resource "aws_lambda_permission" "sales_analytics_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_functions.get_sales_analytics_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# =============================================================================
# GET METHOD: /sentiment
# =============================================================================

resource "aws_api_gateway_method" "sentiment_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.sentiment.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.brand" = false
    "method.request.querystring.limit" = false
  }
}

resource "aws_api_gateway_integration" "sentiment_get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.sentiment.id
  http_method             = aws_api_gateway_method.sentiment_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_functions.get_sentiment_invoke_arn
}

resource "aws_lambda_permission" "sentiment_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_functions.get_sentiment_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# =============================================================================
# GET METHOD: /export
# =============================================================================

resource "aws_api_gateway_method" "export_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.export.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.table"  = false
    "method.request.querystring.format" = false
  }
}

resource "aws_api_gateway_integration" "export_get" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.export.id
  http_method             = aws_api_gateway_method.export_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_functions.export_data_invoke_arn
}

resource "aws_lambda_permission" "export_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_functions.export_data_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# =============================================================================
# CORS CONFIGURATION - OPTIONS METHODS
# =============================================================================

# OPTIONS method for /trends
resource "aws_api_gateway_method" "trends_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.trends.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "trends_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.trends.id
  http_method = aws_api_gateway_method.trends_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "trends_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.trends.id
  http_method = aws_api_gateway_method.trends_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "trends_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.trends.id
  http_method = aws_api_gateway_method.trends_options.http_method
  status_code = aws_api_gateway_method_response.trends_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  # FIXED: Add explicit dependency
  depends_on = [
    aws_api_gateway_method_response.trends_options,
    aws_api_gateway_integration.trends_options
  ]
}

# OPTIONS for /sales-analytics
resource "aws_api_gateway_method" "sales_analytics_options" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.sales_analytics.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sales_analytics_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.sales_analytics.id
  http_method = aws_api_gateway_method.sales_analytics_options.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "sales_analytics_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.sales_analytics.id
  http_method = aws_api_gateway_method.sales_analytics_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "sales_analytics_options" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.sales_analytics.id
  http_method = aws_api_gateway_method.sales_analytics_options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  
  # FIXED: Add explicit dependency
  depends_on = [
    aws_api_gateway_method_response.sales_analytics_options,
    aws_api_gateway_integration.sales_analytics_options
  ]
}

# =============================================================================
# API DEPLOYMENT
# =============================================================================

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.trends.id,
      aws_api_gateway_method.trends_get.id,
      aws_api_gateway_integration.trends_get.id,
      aws_api_gateway_resource.sales_analytics.id,
      aws_api_gateway_method.sales_analytics_get.id,
      aws_api_gateway_integration.sales_analytics_get.id,
      aws_api_gateway_resource.sentiment.id,
      aws_api_gateway_method.sentiment_get.id,
      aws_api_gateway_integration.sentiment_get.id,
      aws_api_gateway_resource.export.id,
      aws_api_gateway_method.export_get.id,
      aws_api_gateway_integration.export_get.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
  
  # Ensure all integrations are created first
  depends_on = [
    aws_api_gateway_integration.trends_get,
    aws_api_gateway_integration.sales_analytics_get,
    aws_api_gateway_integration.sentiment_get,
    aws_api_gateway_integration.export_get,
  ]
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment

  tags = merge(
    var.tags,
    {
      Name = "${local.api_name}-${var.environment}"
    }
  )
}

# REMOVED: CloudWatch logging (requires account-level IAM role in AWS Academy)
# Instead, Lambda functions already have CloudWatch Logs enabled
