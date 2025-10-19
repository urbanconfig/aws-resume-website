output "ssl_certificate_arn" {
  description = "SSL Certificate ARN"
  value       = aws_acm_certificate.ssl_certificate.arn
}

output "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = data.aws_route53_zone.resume_webiste_zone.zone_id
}