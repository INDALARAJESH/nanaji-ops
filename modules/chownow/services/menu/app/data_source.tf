data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy" "ecs_managed_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  source_json = data.aws_iam_policy.ecs_managed_policy.policy

  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/*",
    ]
  }
}

data "aws_iam_policy_document" "ecs_app_policy" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/*",
    ]
  }
  statement {
    effect    = "Allow"
    actions   = ["ssmmessages:CreateControlChannel", "ssmmessages:CreateDataChannel", "ssmmessages:OpenControlChannel", "ssmmessages:OpenDataChannel"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/*",
    ]
  }
}

data "aws_lb_target_group" "tg_web" {
  name = "${var.service}-pub-${local.env}-${var.container_web_port}"
}

data "aws_ssm_parameter" "fluentbit" {
  name = "${var.firelens_container_ssm_parameter_name}/${var.firelens_container_image_version}"
}

data "aws_secretsmanager_secret" "dd_ops_api_key" {
  name = "${local.env}/datadog/ops_api_key"
}

data "aws_secretsmanager_secret_version" "dd_ops_api_key" {
  secret_id     = data.aws_secretsmanager_secret.dd_ops_api_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "db_master_password" {
  name = "${local.env}/${var.service}/db_master_password"
}

data "aws_secretsmanager_secret_version" "db_master_password" {
  secret_id     = data.aws_secretsmanager_secret.db_master_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "db_user_password" {
  name = "${local.env}/${var.service}/db_user_password"
}

data "aws_secretsmanager_secret_version" "db_user_password" {
  secret_id     = data.aws_secretsmanager_secret.db_user_password.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "jwt_auth_secret" {
  name = "${local.env}/${var.service}/jwt_auth_secret"
}

data "aws_secretsmanager_secret_version" "jwt_auth_secret" {
  secret_id     = data.aws_secretsmanager_secret.jwt_auth_secret.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "ld_sdk_key_secret" {
  name = "${local.env}/${var.service}/ld_sdk_key_secret"
}

data "aws_secretsmanager_secret_version" "ld_sdk_key_secret" {
  secret_id     = data.aws_secretsmanager_secret.ld_sdk_key_secret.id
  version_stage = "AWSCURRENT"
}

data "aws_rds_cluster" "db_cluster" {
  cluster_identifier = "menu-mysql-${local.env}"
}

data "aws_lambda_function" "datadog_log_forwarder" {
  function_name = "datadog-forwarder-${var.service}-${local.env}"
}
