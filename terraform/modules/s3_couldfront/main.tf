# Create Origin Access Control for CloudFront to access S3 Bucket
resource "aws_cloudfront_origin_access_control" "cloudfront_s3_website_oac" {
  name                              = "OAC for Website S3 Bucket"
  description                       = "Origin Access Control for CloudFront to access Website S3 Bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "resume_website_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.index_document
  aliases             = [var.root_domain]

  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = "S3-${var.s3_bucket_id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_website_oac.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = "S3-${var.s3_bucket_id}"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.ssl_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# S3 Bucket Policy to allow CloudFront access via Origin Access Control
resource "aws_s3_bucket_policy" "cloudfront_s3_website_oac_policy" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2008-10-17"
    Id      = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_id}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.resume_website_distribution.arn
          }
        }
      }
    ]
  })
}

# Create Route53 Alias Record for CloudFront Distribution
resource "aws_route53_record" "resume_webiste_ailas_record" {
  zone_id = var.route53_zone_id
  name    = var.root_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume_website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.resume_website_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}