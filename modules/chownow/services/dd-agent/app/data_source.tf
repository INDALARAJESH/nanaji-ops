data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_ecs_cluster" "dd_agent" {
  cluster_name = local.cluster_name
}

data "aws_iam_policy" "ecs_execution_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_security_group" "internal_allow" {
  count = local.enable_internal_allow

  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }

}
