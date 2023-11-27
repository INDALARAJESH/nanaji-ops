data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

#########################################
# DMS Environment Variables and Secrets #
#########################################

data "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret" "pgmaster_password" {
  name = "${local.env}/${var.service}/pgmaster_password"
}

data "aws_secretsmanager_secret_version" "pgmaster_password" {
  secret_id     = data.aws_secretsmanager_secret.pgmaster_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "postgres_password" {
  name = "${local.env}/${var.service}/postgres_password"
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id     = data.aws_secretsmanager_secret.postgres_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "redis_auth_token" {
  name = "${local.env}/${var.service}/redis_auth_token"
}

data "aws_secretsmanager_secret_version" "redis_auth_token" {
  secret_id     = data.aws_secretsmanager_secret.redis_auth_token.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "secret_key" {
  name = "${local.env}/${var.service}/secret_key"
}

data "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = data.aws_secretsmanager_secret.secret_key.id
  version_stage = "AWSCURRENT"
}

############
# API Keys #
############

data "aws_secretsmanager_secret" "delighted_api_key" {
  name = "${local.env}/${var.service}/delighted_api_key"
}

data "aws_secretsmanager_secret_version" "delighted_api_key" {
  secret_id     = data.aws_secretsmanager_secret.delighted_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "doordash_api_key" {
  name = "${local.env}/${var.service}/doordash_api_key"
}

data "aws_secretsmanager_secret_version" "doordash_api_key" {
  secret_id     = data.aws_secretsmanager_secret.doordash_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "jolt_api_key" {
  name = "${local.env}/${var.service}/jolt_api_key"
}

data "aws_secretsmanager_secret_version" "jolt_api_key" {
  secret_id     = data.aws_secretsmanager_secret.jolt_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sendgrid_api_key" {
  name = "${local.env}/${var.service}/sendgrid_api_key"
}

data "aws_secretsmanager_secret_version" "sendgrid_api_key" {
  secret_id     = data.aws_secretsmanager_secret.sendgrid_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sentry_dsn" {
  name = "${local.env}/${var.service}/sentry_dsn"
}

data "aws_secretsmanager_secret_version" "sentry_dsn" {
  secret_id     = data.aws_secretsmanager_secret.sentry_dsn.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "new_relic_license_key" {
  name = "${local.env}/${var.service}/new_relic_license_key"
}

data "aws_secretsmanager_secret_version" "new_relic_license_key" {
  secret_id     = data.aws_secretsmanager_secret.new_relic_license_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "uber_secrets" {
  name = "${local.env}/dms/uber_secrets"
}

data "aws_secretsmanager_secret_version" "uber_secrets" {
  secret_id     = data.aws_secretsmanager_secret.uber_secrets.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "launchdarkly_secrets" {
  name = "${local.env}/dms/launchdarkly_secrets"
}

data "aws_secretsmanager_secret_version" "launchdarkly_secrets" {
  secret_id     = data.aws_secretsmanager_secret.launchdarkly_secrets.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "twilio_secrets" {
  name = "${local.env}/dms/twilio_secrets"
}

data "aws_secretsmanager_secret_version" "twilio_secrets" {
  secret_id     = data.aws_secretsmanager_secret.twilio_secrets.id
  version_stage = "AWSCURRENT"
}

#################################
# Redis Primary Endpoint Lookup #
#################################

data "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.service}-redis-${local.env}"
}

###################################
# Private Subnet ID for CodeBuild #
###################################

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private_base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}


#######
# ALB #
#######

data "aws_lb_target_group" "dms_web" {
  name = "${var.service}-pub-${local.env}-${var.container_port}"
}

data "aws_lb_target_group" "dms_cloudflare" {
  name = "${var.service}-cloudflare-backend"
}

#######
# ECR #
#######

data "aws_ecr_repository" "service" {
  name = "${var.service}-${local.env}"
}

#######
# KMS #
#######

# created by modules/chownow/services/dms/base
data "aws_kms_alias" "ecs_env_kms_key_id" {
  name = "alias/dms-kms"
}

#######
# SNS #
#######

data "aws_sns_topic" "order_delivery" {
  name = "cn-order-delivery-events-${local.env}"
}
