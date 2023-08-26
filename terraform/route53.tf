resource "aws_route53_record" "vickers_codes" {
    zone_id     = data.aws_route53_zone.vickers_codes.zone_id
    name        = "vickers.codes"
    type        = "A"

    alias {
        name    = aws_cloudfront_distribution.www_s3_distribution.domain_name
        zone_id = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id
        evaluate_target_health = false
    }
}