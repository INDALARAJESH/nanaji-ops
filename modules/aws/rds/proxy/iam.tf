data "aws_iam_policy_document" "db_proxy_assume" {
  statement {
    sid     = "RDS"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "db_proxy" {
  name        = local.name
  description = format("RDS Proxy basic functionality")

  assume_role_policy = data.aws_iam_policy_document.db_proxy_assume.json

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_iam_role_policy_attachment" "db_proxy" {
  role       = aws_iam_role.db_proxy.name
  policy_arn = aws_iam_policy.db_proxy_secrets_manager.arn
}

resource "aws_iam_policy" "db_proxy_secrets_manager" {
  name   = format("%s_db_proxy_role_policy", var.service)
  policy = data.aws_iam_policy_document.db_proxy_secrets_manager.json
}

data "aws_iam_policy_document" "db_proxy_secrets_manager" {
  statement {
    sid    = "ListSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "GetSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = distinct([for secret in var.secrets : secret.arn])
  }
}
