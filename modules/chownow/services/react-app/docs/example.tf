module "app_marketplace" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/react-app?ref=react-app-v2.0.10"

  env                      = var.env
  service                  = "app-marketplace"
  app_domains              = ["app-marketplace.${var.env}.svpn.chownow.com"]
  codebuild_buildspec_path = "packages/marketplace-web/buildspec.yml"

  # Optional list of zone IDs corresponding to app_domains
  overwrite_zone_ids = ["ASDFASDFASDF", "ZXCVZXCVZXCV"]

  # Data lookup has to have a value for aws_waf_web_acl
  aws_waf_web_acl_id        = "1234-1234-1234-1234-123456778" # WAF enabled

  # Cloudfront Distribution for GDPR users
  gdpr_destination          = "example.cloudfront.net"

  codebuild_environment_variables = [{
    name  = "CF_DISTRIBUTION_ID"
    value = "EXAMPLEID"
  }]

  # Second Origin Settings
  additional_s3_origins  = [{
    domain_name          = "app-example-${var.env}.s3.amazonaws.com"
    origin_id            = "S3-cn-app-example-${var.env}"
    origin_path          = "" # Managed by deployment script
    origin_identity_path = "origin-access-identity/cloudfront/EXAMPLEORIGINID"

  }]

  # Default Caching Behaviors
  allowed_methods = [
    "GET",
    "HEAD",
    "OPTIONS"
  ]

  # Secondary Caching Behaviors
  ordered_cache_behaviors = [{
    target_origin_id      = "S3-cn-app-example-${var.env}"
    path_pattern          = "path/*"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    viewer_protocol_policy   = "redirect-to-https"

    # Lambda@Edge Function Association
    lambda_function_associations = [{
      event_type   = "viewer-request"
      function_arn = "arn:aws:lambda:us-east-1:${var.aws_account_id}:function:cloudfront-sec-headers-qa"
    }]

    # Cloudfront Function Association
    function_associations = [{
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::${var.aws_account_id}:function/app-marketplace-origin-router-${var.env}"
    }]
  }]

  # Custom Errors
  custom_error_responses = [
    {
      error_caching_min_ttl = "0"
      error_code            = "403"
      response_code         = "200"
      response_page_path    = "/index.html"
    },
    {
      error_caching_min_ttl = "0"
      error_code            = "404"
      response_code         = "200"
      response_page_path    = "/index.html"
  }]
}
