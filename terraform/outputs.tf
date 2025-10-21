output "iam_user_name" {
  description = "IAM user for Terraform"
  value       = module.backend.iam_user_arn
}

output "aws_cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for the Resume Website"
  value       = module.s3_cloudfront.aws_cloudfront_distribution_id
}
