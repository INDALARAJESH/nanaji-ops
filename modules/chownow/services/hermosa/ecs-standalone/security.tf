## IAM ECS Resources

data "aws_iam_policy" "ecs_managed_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  source_json = data.aws_iam_policy.ecs_managed_policy.policy

  statement {
    sid     = "AllowFargateReadableSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/FargateReadable"
      values   = ["true"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/${local.service}/*",
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/shared-${var.service}/*",
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/${local.service}/*",
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/shared-${var.service}/*"
    ]
  }
}