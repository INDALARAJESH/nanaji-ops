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
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/${local.service_full}/*",
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/shared-${local.service_deployment}/*",
    ]
  }
}

data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/${local.service_full}/*",
      "arn:aws:secretsmanager:${local.region}:${local.aws_account_id}:secret:${local.env}/shared-${local.service_deployment}/*",
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

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
    ]

    resources = [
      "*",
    ]
  }

  # Required for ECS task protection with long running rpqueue tasks
  statement {
    effect = "Allow"
    actions = [
      "ecs:GetTaskProtection",
      "ecs:UpdateTaskProtection",
    ]

    resources = [
      "*",
    ]
  }

  dynamic "statement" {
    for_each = local.sns_topic_arns

    content {
      effect = "Allow"
      actions = [
        "sns:Publish"
      ]
      resources = [
        statement.value
      ]
    }
  }

  dynamic "statement" {
    for_each = local.sqs_queue_arns

    content {
      effect = "Allow"
      actions = [
        "sqs:Get*",
        "sqs:SendMessage"
      ]
      resources = [
        statement.value
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_logs_cloudwatch_log_group_arn != "" ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]

      resources = [
        var.ssm_logs_cloudwatch_log_group_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_logs_s3_bucket_arn != "" ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectVersionAcl"
      ]
      resources = [
        "${var.ssm_logs_s3_bucket_arn}/*",
        "${var.ssm_logs_s3_bucket_arn}"
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_logs_s3_bucket_arn != "" ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "s3:GetEncryptionConfiguration"
      ]
      resources = [
        var.ssm_logs_s3_bucket_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.ssm_kms_key_arn != "" ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "kms:Decrypt"
      ]
      resources = [
        var.ssm_kms_key_arn,
      ]
    }
  }
}
