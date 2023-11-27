data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_elasticsearch_domain" "restaurant_search" {
  domain_name = "restaurant-search-${local.es_domain_name_suffix}"
}

data "aws_secretsmanager_secret" "es_access_key_id" {
  name = "${local.es_domain_name_suffix}/restaurant-search/es_access_key_id"
}

data "aws_secretsmanager_secret_version" "es_access_key_id" {
  secret_id = data.aws_secretsmanager_secret.es_access_key_id.id
}

data "aws_secretsmanager_secret" "es_secret_access_key" {
  name = "${local.es_domain_name_suffix}/restaurant-search/es_secret_access_key"
}

data "aws_secretsmanager_secret_version" "es_secret_access_key" {
  secret_id = data.aws_secretsmanager_secret.es_secret_access_key.id
}

data "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id = data.aws_secretsmanager_secret.dd_api_key.id
}

data "aws_secretsmanager_secret" "ld_api_key" {
  name = "${local.env}/${var.service}/ld_api_key"
}

data "aws_secretsmanager_secret_version" "ld_api_key" {
  secret_id = data.aws_secretsmanager_secret.ld_api_key.id
}

data "aws_secretsmanager_secret" "hermosa_ld_sdk_key" {
  name = "${local.env}/${var.service}/hermosa_launchdarkly_sdk_key"
}

data "aws_secretsmanager_secret_version" "hermosa_ld_sdk_key" {
  secret_id = data.aws_secretsmanager_secret.hermosa_ld_sdk_key.id
}

data "aws_iam_policy" "managed_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "restaurant_search_ecs_execution" {
  source_json = data.aws_iam_policy.managed_role_policy.policy
  statement {
    actions   = ["logs:*LogEvents", "logs:Create*"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid     = "AllowFargateReadableSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.es_domain_name_suffix}/restaurant-search/es_*",
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/restaurant-search/ld_api_key*",
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/restaurant-search/hermosa_launchdarkly_sdk_key*"
    ]
  }

  statement {
    sid     = "AllowFargateReadableSecretsDatadog"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/*",
    ]

    // ensure we're only accessing fargate readable secrets
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/FargateReadable"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "restaurant_search_ecs_task" {
  statement {
    effect  = "Allow"
    actions = ["es:ES*"]
    resources = [
      "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.service}-*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

data "aws_lb_target_group" "restaurant_search_api" {
  name = "${var.service}-${local.env}-api-tg"
}

data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
