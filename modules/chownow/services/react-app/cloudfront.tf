## Cloudfront
resource "aws_cloudfront_origin_access_identity" "app_origin_access_identity" {
  comment = "access-identity-${var.service}"
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
    domain_name = aws_s3_bucket.app.bucket_domain_name
    origin_id   = "S3-${aws_s3_bucket.app.bucket_domain_name}"
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
  # Second S3 Origin Settings
  dynamic "origin" {
    for_each = var.additional_s3_origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path
      s3_origin_config {
        origin_access_identity = origin.value.origin_identity_path
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.star_svpn.arn
    minimum_protocol_version = var.cloudfront_minimum_ssl_version
    ssl_support_method       = "sni-only"
  }

  # Default Caching Behaviors
  default_cache_behavior {
    allowed_methods            = var.allowed_methods
    cached_methods             = var.cached_methods
    cache_policy_id            = var.cache_policy_id
    response_headers_policy_id = var.response_headers_policy_id

    target_origin_id = "S3-${aws_s3_bucket.app.bucket_domain_name}"

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

    dynamic "lambda_function_association" {
      for_each = var.lambda_function_associations
      content {
        event_type   = lambda_function_association.value.event_type
        include_body = lookup(lambda_function_association.value, "include_body", null)
        lambda_arn   = lambda_function_association.value.lambda_arn
      }
    }

    dynamic "function_association" {
      for_each = var.function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }
  # Secondary Caching Behaviors
  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors

    content {
      path_pattern = ordered_cache_behavior.value.path_pattern

      allowed_methods  = ordered_cache_behavior.value.allowed_methods
      cached_methods   = ordered_cache_behavior.value.cached_methods
      target_origin_id = ordered_cache_behavior.value.target_origin_id

      cache_policy_id            = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id   = ordered_cache_behavior.value.origin_request_policy_id
      response_headers_policy_id = ordered_cache_behavior.value.response_headers_policy_id

      dynamic "forwarded_values" {
        # If a cache policy or origin request policy is specified, we cannot include a `forwarded_values` block at all in the API request
        for_each = ordered_cache_behavior.value.cache_policy_id == null || ordered_cache_behavior.value.origin_request_policy_id == null ? [true] : []
        content {
          query_string = ordered_cache_behavior.value.forward_query_string
          headers      = ordered_cache_behavior.value.forward_header_values

          cookies {
            forward           = ordered_cache_behavior.value.forward_cookies
            whitelisted_names = ordered_cache_behavior.value.whitelisted_names
          }
        }
      }

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy


      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_associations
        content {
          event_type   = lambda_function_association.value.event_type
          include_body = lookup(lambda_function_association.value, "include_body", null)
          lambda_arn   = lambda_function_association.value.lambda_arn
        }
      }

      dynamic "function_association" {
        for_each = lookup(ordered_cache_behavior.value, "function_associations", [])
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
    }
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

  # Managed by deployment script post-provisioning
  lifecycle {
    ignore_changes = [
      origin
    ]
  }


  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "${var.service}-${local.env}"
    )
  )
}
