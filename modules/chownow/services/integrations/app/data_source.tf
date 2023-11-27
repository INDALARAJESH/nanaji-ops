## Network

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_lb" "public" {
  name = "${local.service}-pub-${local.env}"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
}

## IAM

data "aws_iam_role" "ecs_task_manage_etl_cron" {
  name = "cloudwatch-events-ecs-${local.env}"
}

## ECR

data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}

## Secrets

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "hermosa_api_key" {
  name = "${local.env}/shared-${var.service}/hermosa_api_key"
}

data "aws_secretsmanager_secret_version" "hermosa_api_key" {
  secret_id     = data.aws_secretsmanager_secret.hermosa_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "new_relic_license_key" {
  name = "${local.env}/shared-${var.service}/new_relic_license_key"
}

data "aws_secretsmanager_secret_version" "new_relic_license_key" {
  secret_id     = data.aws_secretsmanager_secret.new_relic_license_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "pgmaster_password" {
  name = "${local.env}/${local.service}/pgmaster_password"
}

data "aws_secretsmanager_secret_version" "pgmaster_password" {
  secret_id     = data.aws_secretsmanager_secret.pgmaster_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "postgres_password" {
  name = "${local.env}/${local.service}/postgres_password"
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id     = data.aws_secretsmanager_secret.postgres_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "redis_auth_token" {
  name = "${local.env}/${local.service}/redis_auth_token"
}

data "aws_secretsmanager_secret_version" "redis_auth_token" {
  secret_id     = data.aws_secretsmanager_secret.redis_auth_token.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "secret_key" {
  name = "${local.env}/${local.service}/secret_key"
}

data "aws_secretsmanager_secret_version" "secret_key" {
  secret_id     = data.aws_secretsmanager_secret.secret_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "slack_menu_webhook" {
  name = "${local.env}/shared-${var.service}/slack_menu_webhook"
}

data "aws_secretsmanager_secret_version" "slack_menu_webhook" {
  secret_id     = data.aws_secretsmanager_secret.slack_menu_webhook.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "sentry_dsn" {
  name = "${local.env}/shared-${var.service}/sentry_dsn"
}

data "aws_secretsmanager_secret_version" "sentry_dsn" {
  secret_id     = data.aws_secretsmanager_secret.sentry_dsn.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "ses_user" {
  name = "${local.env}/shared-${var.service}/ses_user"
}

data "aws_secretsmanager_secret_version" "ses_user" {
  secret_id     = data.aws_secretsmanager_secret.ses_user.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "ses_password" {
  name = "${local.env}/shared-${var.service}/ses_password"
}

data "aws_secretsmanager_secret_version" "ses_password" {
  secret_id     = data.aws_secretsmanager_secret.ses_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "datadog_api_key" {
  name = "${local.env}/shared-${var.service}/datadog_api_key"
}

data "aws_secretsmanager_secret_version" "datadog_api_key" {
  secret_id     = data.aws_secretsmanager_secret.datadog_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_lb_target_group" "main" {
  name = "${data.aws_lb.public.name}-${var.deployment_suffix}"
}
