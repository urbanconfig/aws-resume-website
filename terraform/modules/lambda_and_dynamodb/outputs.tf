output "function_url" {
  description = "The url for lambda function"
  value       = aws_lambda_function_url.lambda_function_url.function_url
}