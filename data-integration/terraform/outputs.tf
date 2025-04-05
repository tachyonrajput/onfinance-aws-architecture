# data-integration/terraform/outputs.tf
output "lambda_function_name" {
  value = aws_lambda_function.stock_data_fetcher.function_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.stock_data_bucket.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.stock_data_table.name
}