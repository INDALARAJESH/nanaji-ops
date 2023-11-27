data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Sherlock Environment Variables and Secrets

data "aws_secretsmanager_secret" "sfdc_username" {
  name = "${local.env}/${var.service}/sfdc_username"
}

data "aws_secretsmanager_secret_version" "sfdc_username" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_username.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sfdc_password" {
  name = "${local.env}/${var.service}/sfdc_password"
}

data "aws_secretsmanager_secret_version" "sfdc_password" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_password.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sfdc_integration_user" {
  name = "${local.env}/${var.service}/sfdc_integration_user"
}

data "aws_secretsmanager_secret_version" "sfdc_integration_user" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_integration_user.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sfdc_integration_password" {
  name = "${local.env}/${var.service}/sfdc_integration_password"
}

data "aws_secretsmanager_secret_version" "sfdc_integration_password" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_integration_password.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "redis_auth_token" {
  name = "${local.env}/${var.service}/redis_auth_token"
}

data "aws_secretsmanager_secret_version" "redis_auth_token" {
  secret_id     = "${data.aws_secretsmanager_secret.redis_auth_token.id}"
  version_stage = "AWSCURRENT"
}

# API Keys

data "aws_secretsmanager_secret" "sentry_dsn" {
  name = "${local.env}/${var.service}/sentry_dsn"
}

data "aws_secretsmanager_secret_version" "sentry_dsn" {
  secret_id     = "${data.aws_secretsmanager_secret.sentry_dsn.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sfdc_api_key" {
  name = "${local.env}/${var.service}/sfdc_api_key"
}

data "aws_secretsmanager_secret_version" "sfdc_api_key" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_api_key.id}"
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sfdc_api_secret" {
  name = "${local.env}/${var.service}/sfdc_api_secret"
}

data "aws_secretsmanager_secret_version" "sfdc_api_secret" {
  secret_id     = "${data.aws_secretsmanager_secret.sfdc_api_secret.id}"
  version_stage = "AWSCURRENT"
}

# Private Subnet ID for CodeBuild

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private_base" {
  vpc_id = "${data.aws_vpc.selected.id}"

  filter {
    name   = "tag:NetworkZone"
    values = ["${var.vpc_private_subnet_tag_key}"]
  }
}

# ACM Certificate

data "aws_acm_certificate" "star_chownow" {
  domain   = "${var.wildcard_domain_prefix}${local.env}.svpn.${var.domain}"
  statuses = ["ISSUED"]
}

# ALB
data "aws_security_group" "ingress_vpn_allow" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-vpn-sg-${local.env}"]
  }
}

data "aws_route53_zone" "public" {
  name         = "${local.dns_zone}."
  private_zone = false
}

# DynamoDB
data "aws_dynamodb_table" "table_name" {
  name = "${var.service}-dynamodb-${var.env}"
}

# Datadog
data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = "${data.aws_secretsmanager_secret.dd_ops_api_key.id}"
  version_stage = "AWSCURRENT"
}

# Firelens
data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}
