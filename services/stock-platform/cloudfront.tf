resource "aws_cloudfront_distribution" "stock-platform-cloudfront" {
  origin {
    domain_name = trimprefix(aws_apigatewayv2_api.stock-platform-apigw.api_endpoint, "https://")
    origin_id   = "stock-platform-apigw"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
  aliases = ["osakeanti.evon.fi"]

  // FIXME: this should be changed for s3!
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "stock-platform-apigw"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "stock-platform-apigw"

    // FIXME: deprecated use aws_cloudfront_cache_policy!
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    min_ttl                = 0
    default_ttl            = 900
    max_ttl                = 900
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm-certificate-arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    service = "stock-platform"
  }
}

variable "acm-certificate-arn" {}
