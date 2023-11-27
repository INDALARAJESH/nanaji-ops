data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "chownowapi" {
  name = local.route53_zone_mapping[local.env]
}

data "aws_secretsmanager_secret" "launch_darkly_sdk_key" {
  name = "${local.env}/${local.service}/launch_darkly_sdk_key"
}

data "aws_secretsmanager_secret_version" "launch_darkly_sdk_key" {
  secret_id     = data.aws_secretsmanager_secret.launch_darkly_sdk_key.id
  version_stage = "AWSCURRENT"
}

locals {
  route53_zone_mapping = {
    "ncp" = "chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "qa"  = "qa.chownowapi.com"
    "uat" = "uat.chownowapi.com"
    "stg" = "stg.chownowapi.com"
    "dev" = "dev.chownowapi.com"
    # prod does not have a chownowapi.com domain
  }
}

data "aws_acm_certificate" "cert" {
  domain      = local.route53_zone_mapping[local.env]
  statuses    = ["ISSUED"]
  most_recent = true
}
