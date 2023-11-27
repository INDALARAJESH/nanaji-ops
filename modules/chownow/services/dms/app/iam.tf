# IAM principals and permissions junk drawer
# each ECS service needs two things: a task role and an execution role
# a task role is "inherited by" the containers in a task:
#    it gives our running code permission to interact with AWS APIs, or be used in identity based policies
# an execution role is used by the ECS service to schedule our tasks:
#     it gives the ECS service the ability to interact with load balancers, pull secrets and images, etc, on behalf of our code

data "aws_iam_policy" "ecs_managed_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# create the execution role and bind the execution role policy to it
resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.dms_execution_role_permissions.arn
}
resource "aws_iam_role" "execution" {
  name = "dms-web-ecs-execution-${local.env}"
  path = "/${local.env}/dms-web/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "dms-web-ecs-execution-${local.env}"
  }
}

# create the task role and bind the task role policy to it
# for legacy reasons the task role is named the "app" role
resource "aws_iam_role_policy_attachment" "app" {
  role       = aws_iam_role.app.name
  policy_arn = aws_iam_policy.ecs_web_policy.arn
}
resource "aws_iam_role" "app" {
  name = "dms-web-ecs-app-role-${local.env}"
  path = "/${local.env}/dms-web/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "dms-web-ecs-app-role-${local.env}"
  }
}

# this could probably be an inline policy or an inline document, but for legacy
# reasons, we kept it decomposed like this.  provides the execution role iam actions
# by looking up the ecs_execution_policy document and formatting as json
resource "aws_iam_policy" "dms_execution_role_permissions" {
  name   = "dms-web-execution-${local.env}"
  path   = "/${local.env}/dms-web/"
  policy = data.aws_iam_policy_document.ecs_execution_policy.json
}

data "aws_iam_policy_document" "ecs_execution_policy" {
  source_json = data.aws_iam_policy.ecs_managed_policy.policy

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
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/*",
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/shared-${var.service}/*",
    ]
  }
}

# same structure as previous, provides the web service task role policy by looking
# up the ecs_web_policy document and returning it as json. both of these are consumed
# by the binding resources up near the top of this file.
resource "aws_iam_policy" "ecs_web_policy" {
  name = "dms-web-app-${local.env}"
  path = "/${local.env}/dms-web/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:Create*"
        ]
        Resource = ["arn:aws:logs:*:*:*"]
      },
      {
        Effect = "Allow",
        Action = ["secretsmanager:GetSecretValue"]
        Resource = [
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}*",
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/*",
          "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = ["kms:Encrypt", "kms:Decrypt"]
        Resource = [data.aws_kms_alias.ecs_env_kms_key_id.target_key_arn]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObjectAcl",
          "s3:DeleteObject",
        ]
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}/*",
          "arn:aws:s3:::${local.s3_bucket_name}"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["sns:Publish"]
        Resource = [data.aws_sns_topic.order_delivery.arn]
      }
    ]
  })
}
