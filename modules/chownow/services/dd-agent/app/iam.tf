###########################
# EXECUTION IAM RESOURCES #
###########################

resource "aws_iam_role" "execution" {
  name               = "execution-${local.name}"
  assume_role_policy = file("${path.module}/files/assume_role.json")

  tags = merge(local.common_tags, { "Name" = "execution-${local.name}" })
}

resource "aws_iam_role_policy_attachment" "execution_builtin" {
  role       = aws_iam_role.execution.id
  policy_arn = data.aws_iam_policy.ecs_execution_policy.arn
}

data "aws_iam_policy_document" "execution_secrets" {
  statement {
    sid     = "AllowFargateReadableSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/*",
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
      "${local.dd_api_key_arn}*",
      "${local.config_secret_arn}*"
    ]
  }
}

resource "aws_iam_policy" "execution_secrets" {
  name        = "execution-secrets-${local.name}"
  description = "execution secret policy for ${local.name}"
  path        = "/${local.env}/${var.service}/"
  policy      = data.aws_iam_policy_document.execution_secrets.json

  tags = merge(local.common_tags, { "Name" = "execution-secrets-${local.name}" })
}

resource "aws_iam_role_policy_attachment" "execution_secrets" {
  role       = aws_iam_role.execution.id
  policy_arn = aws_iam_policy.execution_secrets.arn
}


######################
# TASK IAM RESOURCES #
######################

resource "aws_iam_role" "task" {
  name               = "task-${local.name}"
  assume_role_policy = file("${path.module}/files/assume_role.json")

  tags = merge(local.common_tags, { "Name" = "task-${local.name}" })
}

data "aws_iam_policy_document" "task" {
  statement {
    sid    = "AllowECSExcute"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]

  }

  statement {
    sid     = "AllowReadSecrets"
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "${local.dd_api_key_arn}*",
      "${local.config_secret_arn}*"
    ]
  }
}

resource "aws_iam_policy" "task" {
  name        = "task-${local.name}"
  description = "task policy for ${local.name}"
  path        = "/${local.env}/${var.service}/"
  policy      = data.aws_iam_policy_document.task.json

  tags = merge(local.common_tags, { "Name" = "task-${local.name}" })
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.id
  policy_arn = aws_iam_policy.task.arn
}
