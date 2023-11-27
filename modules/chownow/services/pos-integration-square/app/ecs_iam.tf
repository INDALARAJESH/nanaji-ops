# This policy is required by tasks to pull container images and publish container logs to Amazon CloudWatch on your behalf
data "aws_iam_policy_document" "ecs_execution_policy" {
  statement {
    sid    = "CW"
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid    = "ECR"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "secret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      format(
        "arn:aws:secretsmanager:%s:%s:secret:%s/%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.env,
        local.app_name
      ),
      "${data.aws_secretsmanager_secret.dd_api_key.arn}*"
    ]
  }
}

# This policy is used by running tasks
data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    sid    = "secret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      format(
        "arn:aws:secretsmanager:%s:%s:secret:%s/%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.env,
        local.app_name
      ),
      "${data.aws_secretsmanager_secret.dd_api_key.arn}*"
    ]
  }
}
