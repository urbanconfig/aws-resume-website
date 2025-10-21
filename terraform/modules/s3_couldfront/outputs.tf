output "aws_cloudfront_distribution_id" {
  description = "CloudFront Distribution ID for the Resume Website"
  value       = aws_cloudfront_distribution.resume_website_distribution.id
}