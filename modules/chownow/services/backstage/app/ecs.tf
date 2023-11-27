locals {
  region         = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id
}


data "aws_iam_policy_document" "ecs_execution_iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:Create*"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${var.env}/${var.service}/*"
    ]
  }

  statement {
    sid     = "AllowFargateReadableSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${var.env}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/FargateReadable"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${var.env}/${var.service}/*"
    ]
  }
}

module "ecs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/base?ref=aws-ecs-base-v2.1.5"

  container_name            = var.service
  container_port            = var.container_port
  ecs_service_tg_arn        = module.alb_ecs_tg.tg_arn
  env                       = var.env
  service                   = var.service
  vpc_name_prefix           = var.vpc_name_prefix
  service_role              = "web"
  ecs_service_desired_count = var.ecs_service_desired_count
  td_container_definitions  = jsonencode(local.container_definitions)
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_iam_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_iam_policy.json
  wait_for_steady_state     = var.wait_for_steady_state
}
