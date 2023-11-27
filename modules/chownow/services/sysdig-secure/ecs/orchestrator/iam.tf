resource "aws_iam_role" "ecs_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_execution_assume_role_policy.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    aws_iam_policy.ecs_execution_policy.arn
  ]

  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.service}-ecs-execution-${var.vpc_name}"
    }
  )
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name   = "${var.service}-execution-${var.vpc_name}"
  path   = "/${local.env}/${var.service}/"
  policy = data.aws_iam_policy_document.ecs_execution_policy.json

  tags = merge(
    local.common_tags,
    tomap({
      "Name" = "${var.service}-ecs-execution-${var.vpc_name}",
    })
  )
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    sid     = "AllowSysdigSecureSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/sysdig-secure/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/FargateReadable"
      values   = ["true"]
    }
  }
}

data "aws_iam_policy_document" "ecs_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
