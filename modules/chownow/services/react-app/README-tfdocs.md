<!-- BEGIN_TF_DOCS -->
# React-app stack

This is a module to assemble components needed for ChowNow's React-based frontend apps. Components:

  1. S3 bucket to store the React-based static single page app
  1. Codebuild project to deploy it
  1. Cloudfront distribution to serve it
  1. Route53 record to find it
  1. S3-triggered lambda to cull older builds

![chownow-services-react-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-react-app/badge.svg)

## Important Considerations
Inherent limitations within terraform make it impossible for the module to work as hoped and instead, workarounds are needed which make use the module trickier than most.

### Limitation 1 - data source lookups on lambda don't return a proper version
When using a data source lookup on a lambda, the value for the `version` attribute returns simply as `$LATEST` rather than the actual value. The lambda in question here is for use as lambda@EDGE (adding security headers) and as such, will not accept $LATEST and instead *requires* a numerical value.

WORKAROUND: lambda_function_association must be passed in explicitly.

Reference: https://github.com/hashicorp/terraform-provider-aws/issues/10038

### Limitation 2 - interpolation of resource attributes don't function for codebuild environment variable definitions

For example, you can't create a cloudfront resource, then try to define a codebuild enviornment variable as
```
 environment_variable {
  name = "CF_DISTRIBUTION_ID"
  value =  aws.cloudfront_distribution.me.id
 }
```
You get an error such as
```
https://github.com/hashicorp/terraform-provider-aws/issues/6538
```

WORKAROUND: terraform the service, then update by passing in the actual CF_DISTRIBUTION_ID from the created resource

Reference: https://github.com/hashicorp/terraform-provider-aws/issues/6538 (closed, but did not address the problem with codebuild env vars)

## Usage

* Terraform:

```hcl
module "app_marketplace" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/react-app?ref=react-app-v2.0.13"

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
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_s3\_origins | List for custom S3 Origins | `list` | `[]` | no |
| allowed\_methods | List of allowed methods (e.g. GET, PUT, POST, DELETE, HEAD) for AWS CloudFront | `list` | ```[ "GET", "HEAD", "OPTIONS" ]``` | no |
| app\_domains | Domain names accepted by cloudfront | `list(string)` | n/a | yes |
| aws\_waf\_web\_acl\_id | WAF Web ACL id | `any` | n/a | yes |
| cache\_policy\_id | Cache Policy ID | `any` | `null` | no |
| cached\_methods | List of cached methods (e.g. GET, PUT, POST, DELETE, HEAD) | `list` | ```[ "GET", "HEAD" ]``` | no |
| cloudfront\_minimum\_ssl\_version | n/a | `string` | `"TLSv1.2_2021"` | no |
| codebuild\_buildspec\_path | Path to buildspec | `any` | n/a | yes |
| codebuild\_environment\_variables | Additional vars, to be merged with standard ones | `any` | n/a | yes |
| codebuild\_image | Codebuild container image | `string` | `"aws/codebuild/standard:4.0"` | no |
| codebuild\_source\_location | Source repo for codebuild | `string` | `"https://github.com/ChowNow/chownow-web.git"` | no |
| cors\_rule | n/a | `list` | `[]` | no |
| custom\_error\_responses | List of one or more custom error response element maps | `list` | `[]` | no |
| custom\_headers | n/a | `list` | `[]` | no |
| domain | domain name information | `string` | `"chownow.com"` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | additional tags | `map` | `{}` | no |
| filter\_prefix | Filter\_prefix for react-app build | `string` | `"build-"` | no |
| filter\_suffix | Filter suffix for AWS S3 nofitication | `string` | `"index.html"` | no |
| forward\_cookies | Specifies whether you want CloudFront to forward all or no cookies to the origin. Can be 'all' or 'none' | `string` | `"none"` | no |
| forward\_header\_values | A list of whitelisted header values to forward to the origin (incompatible with `cache_policy_id`) | `list` | ```[ "Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin" ]``` | no |
| forward\_query\_string | Forward query strings to the origin that is associated with this cache behavior (incompatible with `cache_policy_id`) | `bool` | `false` | no |
| forwarded\_values | n/a | `list` | `[]` | no |
| function\_associations | A config block that triggers a cloudfront function with specific actions | `list` | `[]` | no |
| gdpr\_destination | destination for users coming from EU | `any` | n/a | yes |
| gdpr\_geo\_continent | GDPR geolocation continent, star indicates default policy | `string` | `"EU"` | no |
| lambda\_function\_associations | A config block that triggers a lambda@edge function with specific actions | `list` | `[]` | no |
| ordered\_cache\_behaviors | Ordered Cache settings | `list` | `[]` | no |
| origin\_path | An optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin. It must begin with a /. Do not add a / at the end of the path. | `string` | `""` | no |
| overwrite\_zone\_ids | list of zone IDs corresponding to the list of app\_domains | `string` | `""` | no |
| publish | Publish s3 lambda | `string` | `"false"` | no |
| query\_string\_cache\_keys | When `forward_query_string` is enabled, only the query string keys listed in this argument are cached (incompatible with `cache_policy_id`) | `list` | `[]` | no |
| response\_headers\_policy\_id | n/a | `any` | `null` | no |
| service | name of service, used in interpolations | `any` | n/a | yes |
| subdomain | subdomain name information | `string` | `""` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| whitelisted\_names | n/a | `list` | `[]` | no |
| wildcard\_domain\_prefix | Custom prefix used for looking up wild card cert (sometimes = '*.') | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | The arn of the lambda |
| lambda\_version | The version of the lambda |



---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
