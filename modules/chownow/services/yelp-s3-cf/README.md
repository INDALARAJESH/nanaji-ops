# 

This is a module to assemble components needed to support yelp.chownow.com and related efforts with a S3 cloudfront setup

It is largely a copy of the react-app module but it does not manage codebuild or s3. It simply makes a cloudfront distribution and redirects it to the s3 bucket.

## Usage

```
module "yelp-s3" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/yelp-s3-cf?ref=cn-yelp-s3-cf-v2.0.1"

  env                      = var.env
  service                  = "yelp"
  app_domains              = ["yelp.${var.env}.svpn.chownow.com"]

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

For env=uat, this results in:
  1. S3 bucket named `cn-app-marketplace-uat`
  2. Codebuild project named `app-marketplace-codebuild-uat`
  3. Cloudfront distribution with comment `app-marketplace-uat`
  4. Route53 record `app-marketplace.uat.svpn.chownow.com`
  5. S3-triggered lambda named `s3_cleanup-cn-app-marketplace-uat`

### Inputs

#### General
| Variable Name                   | Description                               | Notes                                                         |  Type   | Req? |
| :------------------------       | :-------------------------------------    | :-----------------------------------------------------------  | :-----: | :--: |
| app_domains                     | domains names served by Cloudfront        | eg [`app-marketplace.uat.svpn.chownow.com`]                   | List    |  Yes |
| domain                          | dns zone name override                    | defaults to chownow.com for prod, env.svpn.chownow.com        | String  |  No  |
| subdomain                       | subdomain name information                | defaults to ""                                                | String  |  No  |
| env_inst                        | stage instance                            | 00,01,02 etc (default:`''`)                                   | String  |  No  |
| env                             | unique environment/stage name             | sandbox/dev/qa/uat/stg/prod/etc                               | String  |  Yes |
| extra_tags                      | additional tagging to apply               | eg `{ "Owner": "DataEng" }`                                   | Map     |  No  |
| service                         | name of service (use for resource naming) | eg `app-marketplace`                                          | String  |  Yes |
| tag_managed_by                  | ManagedBy tag value                       | (default:`Terraform`))                                        | String  |  No  |
| wildcard_domain_prefix          | prefix to search certificates for         | eg `*` (default:`''`)                                         | String  |  No  |
| gdpr_destination                | cloudfront distrubution                   | eg `d19qasdt128d0j.cloudfront.net`                            | String  |  Yes |


#### Codebuild

| Variable Name                   | Description                               | Notes                                                         |  Type   | Req? |
| :------------------------       | :-------------------------------------    | :-----------------------------------------------------------  | :-----: | :--: |
| codebuild_buildspec_path        | Path to buildspec file                    | eg `packages/marketplace-web/buildspec.yml`                   | String  |  Yes |
| codebuild_environment_variables | Additional envs on top of standard ones   | eg `[{ name = "CF_DISTRIBUTION_ID", value = "EXXXYYYZZZ" }]`  | List    |  No  |
| codebuild_image                 | Container image id for codebuild          | default:`aws/codebuild/standard:4.0`                          | String  |  No  |
| codebuild_source_location       | Source repo for codebuild                 | default:`https://github.com/ChowNow/chownow-web.git`          | String  |  No  |

#### Cloudfront

| Variable Name                   | Description                               | Notes                                                         |  Type   | Req? |
| :------------------------       | :-------------------------------------    | :-----------------------------------------------------------  | :-----: | :--: |
| aws_waf_web_acl_id              | WAF Web ACL ID                            | eg `cbf39fa6-f101-4e8d-94ff-5a5cd585fc8f`                     | String  |  No  |
| origin_path                     | Amazon S3 bucket or your custom origin    | eg `order/*`                                                  | String  |  No  |
| additional_s3_origins           | List for custom S3 Origins Settings       | eg `[{domain_name = "app-example.s3.amazonaws.com}]"`         | List    |  No  |
| allowed_methods                 | List allowed methods                      | default: ["GET", "HEAD", "OPTIONS"]                           | List    |  No  |
| cached_methods                  | List of cached methods                    | default: ["GET", "HEAD"]                                      | List    |  No  |
| cache_policy_id                 | Cache Policy ID                           | defaults: null                                                | String  |  No  |
| response_headers_policy_id      | Response headers, see OPS-2913            | defaults: null                                                | String  |  No  |
| query_string_cache_keys         | incompatible with `cache_policy_id`       | defaults: []                                                  | list    |  No  |
| forward_header_values           | A list of whitelisted header              | defaults: ["..Request-Headers", "..Request-Method", "Origin"] | list    |  No  |
| forward_cookies                 | unique environment/stage name             | defaults: `none`                                              | String  |  No  |
| lambda_function_associations    | Lambda@Edge (limit: 4)                    | Refer to module usage section                                 | List    |  No  |
| function_associations           | Cloudfront Functions   (limit: 2)         | Refer to module usage section                                 | List    |  No  |
| ordered_cache_behaviors         | Ordered Cache settings                    | Refer to module usage section                                 | List    |  No  |
| custom_error_responses          | Custom Error Response                     | Refer to module usage section                                 | List    |  No  |
| minimum_ssl_version             | Viewer certificate ssl version            | https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html | List    |  No  |

#### Outputs

(none)
