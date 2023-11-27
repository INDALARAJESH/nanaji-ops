## Network

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_acm_certificate" "public" {
  domain      = local.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_route53_zone" "public" {
  name         = "${local.env}.${var.domain_public}"
  private_zone = false
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_lb" "alb" {
  name = local.alb_name
}

data "aws_lb_listener" "alb" {
  load_balancer_arn = data.aws_lb.alb.arn
  port              = 443
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
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

data "aws_secretsmanager_secret" "ssl_key" {
  name = "${local.env}/shared-${var.service}/ssl_key"
}

data "aws_secretsmanager_secret_version" "ssl_key" {
  secret_id     = data.aws_secretsmanager_secret.ssl_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "ssl_cert" {
  name = "${local.env}/shared-${var.service}/ssl_cert"
}

data "aws_secretsmanager_secret_version" "ssl_cert" {
  secret_id     = data.aws_secretsmanager_secret.ssl_cert.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "configuration" {
  name = "${local.env}/shared-${var.service}/configuration"
}

data "aws_secretsmanager_secret_version" "configuration" {
  secret_id     = data.aws_secretsmanager_secret.configuration.id
  version_stage = "AWSCURRENT"
}

# Lookup for primary vpc info in non-prod environments
data "aws_vpc" "primary" {
  count = var.env == "ncp" ? 0 : 1

  filter {
    name   = "tag:Name"
    values = [local.env]
  }
}

data "aws_ecs_cluster" "existing" {
  cluster_name = local.cluster_name
}
