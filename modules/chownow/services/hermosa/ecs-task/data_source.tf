data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ecs_cluster" "this" {
  cluster_name = var.cluster_name
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_security_group" "internal" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}

data "aws_lb" "sysdig_orchestrator" {
  count = var.enable_sysdig ? 1 : 0
  tags = {
    "Name" = "sysdig-orchestrator-${var.vpc_name}"
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
