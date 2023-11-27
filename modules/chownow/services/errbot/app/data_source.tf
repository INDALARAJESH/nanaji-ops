# General Data Lookup
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

# Security Group
data "aws_security_group" "selected" {
  name = "internal-${local.env}"
}

# Shared Cluster ID
data "aws_ecs_cluster" "selected" {
  cluster_name = "shared-${local.env}"
}

# Security Group
data "aws_security_group" "internal" {
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}

# Secrets Keys

# Jenkins
data "aws_secretsmanager_secret" "jenkins_password" {
  name = "${local.env}/${var.service}/jenkins_password"
}

data "aws_secretsmanager_secret_version" "jenkins_password" {
  secret_id     = data.aws_secretsmanager_secret.jenkins_password.id
  version_stage = "AWSCURRENT"
}

# Slack
data "aws_secretsmanager_secret" "slack_bot_token" {
  name = "${local.env}/${var.service}/slack_bot_token"
}

data "aws_secretsmanager_secret_version" "slack_bot_token" {
  secret_id     = data.aws_secretsmanager_secret.slack_bot_token.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "bot_admins" {
  name = "${local.env}/${var.service}/bot_admins"
}

data "aws_secretsmanager_secret_version" "bot_admins" {
  secret_id     = data.aws_secretsmanager_secret.bot_admins.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "slack_app_token" {
  name = "${local.env}/${var.service}/slack_app_token"
}

data "aws_secretsmanager_secret_version" "slack_app_token" {
  secret_id     = data.aws_secretsmanager_secret.slack_app_token.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "slack_signing_secret" {
  name = "${local.env}/${var.service}/slack_signing_secret"
}

data "aws_secretsmanager_secret_version" "slack_signing_secret" {
  secret_id     = data.aws_secretsmanager_secret.slack_signing_secret.id
  version_stage = "AWSCURRENT"
}

# Datadog
data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

# Firelens
data "aws_ssm_parameter" "fluentbit" {
  name = "/aws/service/aws-for-fluent-bit/2.10.1"
}
