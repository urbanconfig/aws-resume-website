output "s3_bucket_id" {
  description = "Resume website S3 Bucket ID"
  value       = aws_s3_bucket.resume_website_bucket.id
}

output "s3_bucket_arn" {
  description = "Resume website S3 Bucket ARN"
  value       = aws_s3_bucket.resume_website_bucket.arn
}

output "website_url" {
  description = "value"
  value       = "http://${aws_s3_bucket.resume_website_bucket.bucket}.s3-website-${var.region}.amazonaws.com"
}

output "index_document" {
  description = "Index document suffix of the S3 Website Bucket"
  value       = var.index_document_suffix
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 Website Bucket"
  value       = aws_s3_bucket.resume_website_bucket.bucket_regional_domain_name
}