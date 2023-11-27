locals {
  env = var.vpc_name_prefix != "" ? "${var.vpc_name_prefix}-${var.env}" : var.env
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_acm_certificate" "star_chownow" {
  domain      = "${var.env}.${var.domain_public}"
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "public" {
  name         = "${var.env}.${var.domain_public}"
  private_zone = false
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [local.env]
  }
}

data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${var.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_db_instance" "database" {
  db_instance_identifier = var.db_instance_identifier
}

data "aws_secretsmanager_secret" "database_password" {
  name = "${var.env}/${var.service}/${var.db_password_secret_name}"
}

data "aws_secretsmanager_secret" "github_catalog_integration_secret" {
  name = "${var.env}/${var.service}/${var.github_catalog_integration_secret_name}"
}

data "aws_secretsmanager_secret" "github_client_id" {
  name = "${var.env}/${var.service}/${var.github_oauth_app_client_id_secret_name}"
}

data "aws_secretsmanager_secret" "github_client_secret" {
  name = "${var.env}/${var.service}/${var.github_oauth_app_client_secret_name}"
}
