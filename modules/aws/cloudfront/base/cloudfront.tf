resource "aws_cloudfront_response_headers_policy" "security_headers_global" {
  name = "chownow-security-headers"
  security_headers_config {
    strict_transport_security {
      access_control_max_age_sec = 31536000
      override                   = true
      preload                    = false
      include_subdomains         = false
    }
    xss_protection {
      protection = true
      mode_block = true
      override   = true
    }
    content_type_options {
      # this seems to implicity set "nosniff", according to the documentation
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_response_headers_policy#content-type-options
      override = true
    }
    referrer_policy {
      override        = true
      referrer_policy = "strict-origin-when-cross-origin"
    }
    frame_options {
      frame_option = "SAMEORIGIN"
      override     = true
    }
  }
}
