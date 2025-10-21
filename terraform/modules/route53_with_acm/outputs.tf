output "ssl_certificate_arn" {
  description = "SSL Certificate ARN"
  value       = aws_acm_certificate.ssl_certificate.arn
}

output "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = data.aws_route53_zone.resume_webiste_zone.zone_id
}

output "root_domain" {
  description = "The root domain for the Resume Website"
  value       = var.dns_zone_domain
}