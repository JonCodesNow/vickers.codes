resource "aws_cloudfront_origin_access_control" "vickers_codes" {
  name                              = "vickers.codes"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "www_s3_distribution" {
  origin {
    domain_name = "vickers.codes.s3.amazonaws.com"
    origin_id   = "S3-www.${var.bucket_name}" 
    origin_access_control_id = aws_cloudfront_origin_access_control.vickers_codes.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_name]

  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-www.${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn    = aws_acm_certificate.ssl_certificate.arn
    ssl_support_method     = "sni-only"
  }
}