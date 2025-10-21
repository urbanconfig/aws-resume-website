# Retrieve the Route 53 hosted zone based on the provided domain name
data "aws_route53_zone" "resume_webiste_zone" {
  name         = var.dns_zone_domain
  private_zone = false
}

# Create an ACM SSL certificate for the specified domain and its wildcard subdomain
resource "aws_acm_certificate" "ssl_certificate" {
  provider = aws.us_region

  domain_name               = var.dns_zone_domain
  subject_alternative_names = ["*.${var.dns_zone_domain}"]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# Create a Route 53 DNS record for domain validation of the ACM certificate
resource "aws_route53_record" "dns_record_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.resume_webiste_zone.zone_id
  ttl             = var.dns_record_ttl
}


# Validate the ACM SSL certificate using the created DNS record
resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
  provider = aws.us_region

  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_record_validation.fqdn]
}
