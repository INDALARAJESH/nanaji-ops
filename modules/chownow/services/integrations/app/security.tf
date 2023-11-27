data "aws_iam_policy_document" "jenkins_s3" {
  statement {
    sid = "AllowAccessTo${replace(title(local.full_service), "-", "")}S3"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.env_file_bucket.bucket_arn}/*",
    ]
  }
}

resource "aws_iam_policy" "jenkins_s3" {
  name        = "${local.full_service}-s3-access"
  description = "${local.full_service}-s3-access"
  policy      = data.aws_iam_policy_document.jenkins_s3.json
}

resource "aws_iam_user_policy_attachment" "jenkins_s3" {
  user       = data.aws_iam_user.jenkins.user_name
  policy_arn = aws_iam_policy.jenkins_s3.arn
}

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
    sid    = "AllowS3AccesstoECS"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetBucketLocation",
    ]

    resources = [
      "${module.env_file_bucket.bucket_arn}",
      "${module.env_file_bucket.bucket_arn}/*",
    ]
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
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/shared-${var.service}/*",
    ]
  }
}
