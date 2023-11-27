## Cloudfront
resource "aws_cloudfront_origin_access_identity" "app_origin_access_identity" {
  comment = "access-identity-${var.service}-${local.env}"
}

resource "aws_cloudfront_distribution" "app_distribution" {

  # General Settings
  comment             = "${var.service}-${local.env}"
  web_acl_id          = var.aws_waf_web_acl_id
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = var.app_domains

  # First Origin Settings
  origin {
    domain_name = data.aws_s3_bucket.app.bucket_domain_name
    origin_id   = "S3-${data.aws_s3_bucket.app.bucket_domain_name}"
    origin_path = var.origin_path
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app_origin_access_identity.cloudfront_access_identity_path
    }
    dynamic "custom_header" {
      for_each = var.custom_headers == null ? [true] : []
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  # Default Caching Behaviors
  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    cache_policy_id            = var.cache_policy_id
    response_headers_policy_id = var.response_headers_policy_id

    target_origin_id = "S3-${data.aws_s3_bucket.app.bucket_domain_name}"

    forwarded_values {
      # If a cache policy or origin request policy is specified, we cannot include a `forwarded_values` block at all in the API request
      query_string            = var.forward_query_string
      query_string_cache_keys = var.query_string_cache_keys
      headers                 = var.forward_header_values

      cookies {
        forward           = var.forward_cookies
        whitelisted_names = var.whitelisted_names
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  logging_config {
    bucket          = data.aws_s3_bucket.cloudfront_access_logs.bucket_domain_name
    prefix          = var.service
    include_cookies = true
  }

}
