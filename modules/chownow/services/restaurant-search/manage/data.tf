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

data "aws_iam_policy" "managed_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "restaurant_search_ecs_execution" {
  source_policy_documents = [data.aws_iam_policy.managed_role_policy.policy]
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
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/restaurant-search/es_*"
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
}

data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
