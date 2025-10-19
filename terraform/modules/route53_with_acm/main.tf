data "aws_route53_zone" "resume_webiste_zone" {
  name         = var.dns_zone_domain
  private_zone = false
}

resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.dns_zone_domain
  subject_alternative_names = ["*.${var.dns_zone_domain}"]
  validation_method         = "DNS"
  region                    = var.cert_region
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "dns_record_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.ssl_certificate.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.resume_webiste_zone.zone_id
  ttl             = var.dns_record_ttl
}



resource "aws_acm_certificate_validation" "ssl_certificate_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [aws_route53_record.dns_record_validation.fqdn]
}
