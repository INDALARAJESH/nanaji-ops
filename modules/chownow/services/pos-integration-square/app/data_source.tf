data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "api" {
  name = local.domain_name
}

data "aws_kms_key" "pos_square" {
  key_id = local.key_id
}

data "aws_elasticache_replication_group" "redis" {
  replication_group_id = format("%s-redis-%s", local.app_name, local.env)
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.vpc_name_prefix, local.env)]
  }
}

data "aws_vpc" "env" {
  count = var.env != "ncp" ? 1 : 0

  filter {
    name   = "tag:VPC"
    values = [local.hermosa_vpc_name]
  }
}

data "aws_vpc_endpoint" "api_gw_private" {
  filter {
    name   = "tag:Name"
    values = [format("%s-execute-api-%s", data.aws_vpc.selected.tags.Name, local.app_name)]
  }
}

data "aws_vpc_endpoint" "api_gw_private_vpce_env" {
  count = var.env != "ncp" ? 1 : 0

  filter {
    name   = "tag:Name"
    values = [format("%s-execute-api-%s", concat(data.aws_vpc.env.*.tags.Name, [""])[0], local.hermosa_apigw)]
  }
}

data "aws_sqs_queue" "success_queue" {
  name = format("%s-success-queue-%s", var.name, local.env)
}

data "aws_sqs_queue" "failure_queue" {
  name = format("%s-failure-queue-%s", var.name, local.env)
}

data "aws_cloudwatch_log_group" "gateway" {
  name = format("/aws/api-gateway/%s-log-group-%s", local.app_name, local.env)
}

data "aws_iam_policy" "lambda" {
  name = format("%s_lambda", local.app_name)
}

data "aws_security_group" "ecs_service_app" {
  name   = format("%s-ecs-service-sg-%s", local.service, local.env)
  vpc_id = data.aws_vpc.selected.id
}
