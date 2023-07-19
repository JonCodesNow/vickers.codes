resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}"]
  #validation_method         = "EMAIL"
  validation_method         = "DNS"
}

data "aws_route53_zone" "vickers_codes" {
  name         = "vickers.codes"
  private_zone = false
}

resource "aws_route53_record" "vickers_codes" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.example.zone_id
}

resource "aws_acm_certificate_validation" "vickers_codes" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.vickers_codes : record.fqdn]
}



