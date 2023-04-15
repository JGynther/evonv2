resource "aws_cloudfront_distribution" "stock-platform-cloudfront" {
  origin {
    domain_name = trimprefix(aws_apigatewayv2_api.go-link-apigw.api_endpoint, "https://")
    origin_id   = "go-link-apigw"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled     = true
  aliases     = ["go.evon.fi"]
  price_class = "PriceClass_100"

  // FIXME: this should be changed for s3!
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "go-link-apigw"

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress    = true

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
    service = "go-link"
  }
}

variable "acm-certificate-arn" {}
