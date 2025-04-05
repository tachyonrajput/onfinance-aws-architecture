# data-integration/terraform/main.tf
provider "aws" {
  region = var.region
}

# S3 bucket for storing raw stock data
resource "aws_s3_bucket" "stock_data_bucket" {
  bucket = "${var.project_name}-${var.environment}-stock-data"
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-stock-data"
    Environment = var.environment
  }
}

# DynamoDB table for processed stock data
resource "aws_dynamodb_table" "stock_data_table" {
  name           = "${var.project_name}_${var.environment}_stock_data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "symbol"
  range_key      = "date"

  attribute {
    name = "symbol"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  tags = {
    Name        = "${var.project_name}_${var.environment}_stock_data"
    Environment = var.environment
  }
}

# Store API key in Secrets Manager
resource "aws_secretsmanager_secret" "api_key" {
  name = "${var.project_name}/${var.environment}/alpha_vantage_api_key"
  
  tags = {
    Name        = "Alpha Vantage API Key"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "api_key" {
  secret_id     = aws_secretsmanager_secret.api_key.id
  secret_string = var.alpha_vantage_api_key
}

# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_name}_${var.environment}_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom policy for S3, DynamoDB, and Secrets Manager access
resource "aws_iam_policy" "lambda_data_access" {
  name        = "${var.project_name}_${var.environment}_lambda_data_access"
  description = "Allow Lambda to access S3, DynamoDB, and Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.stock_data_bucket.arn}/*"
      },
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Query"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.stock_data_table.arn
      },
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = aws_secretsmanager_secret.api_key.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_data_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_data_access.arn
}

# Lambda function
resource "aws_lambda_function" "stock_data_fetcher" {
  function_name    = "${var.project_name}_${var.environment}_stock_data_fetcher"
  role             = aws_iam_role.lambda_role.arn
  handler          = "stock_data_fetcher.lambda_handler"
  runtime          = "python3.9"
  timeout          = 60
  memory_size      = 256
  
  # Create Lambda package
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME   = aws_s3_bucket.stock_data_bucket.id
      TABLE_NAME    = aws_dynamodb_table.stock_data_table.name
      STOCK_SYMBOLS = var.stock_symbols
      # The actual API key will be retrieved from Secrets Manager at runtime
      ALPHA_VANTAGE_API_KEY = "placeholder" 
    }
  }
}

# EventBridge rule to trigger Lambda daily
resource "aws_cloudwatch_event_rule" "daily_stock_fetch" {
  name                = "${var.project_name}_${var.environment}_daily_stock_fetch"
  description         = "Trigger stock data fetch Lambda every day"
  schedule_expression = "cron(0 22 * * ? *)"  # Run at 10 PM UTC every day
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_stock_fetch.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.stock_data_fetcher.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stock_data_fetcher.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_stock_fetch.arn
}