# Module for base IAM policies that are shared across all lambdas
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_base_policy_ecr" {
  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/pos-toast*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [
      local.image_repository_arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.dd_api_key.arn,
      data.aws_secretsmanager_secret.launch_darkly_sdk_key.arn
    ]
  }
}

data "aws_iam_policy_document" "ssm_param" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter*"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_prefix}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter"
    ]
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_toast_token}"
    ]
  }
}

data "aws_iam_policy_document" "kms_use" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_key.pos_toast_token_encryption.arn
    ]
  }
}

# This should be attached to roles of lambdas that need read access to DynamoDB
data "aws_iam_policy_document" "dynamodb_read" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_table_name}/index/*"
    ]
  }
}

# This should be attached to roles of lambdas that need read access to DynamoDB POSToastOrders
data "aws_iam_policy_document" "dynamodb_orders_table_read" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchGetItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_orders_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_orders_table_name}/index/*"
    ]
  }
}


# This should be attached to roles of lambdas that need write access to DynamoDB
data "aws_iam_policy_document" "dynamodb_write" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_table_name}/index/*"
    ]
  }
}

# This should be attached to roles of lambdas that need write access to the DynamoDB POSToastOrders table
data "aws_iam_policy_document" "dynamodb_orders_table_write" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem"
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_orders_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.db_orders_table_name}/index/*"
    ]
  }
}

# Lambda base policy that should be included in all lambdas
resource "aws_iam_policy" "lambda_base" {
  name        = "${local.service}-lambda-base"
  description = "Base policy for toast lambdas"
  policy      = data.aws_iam_policy_document.lambda_base_policy_ecr.json
}

# Lambda policy to be attached to lambas that need to read from SSM param store in order to access
# params such as Toast Client ID and Secret tokens or Toast API access tokens
resource "aws_iam_policy" "ssm_param" {
  name        = "${local.service}-ssm-param"
  description = "SSM Parameter  policy for ${local.service}"
  policy      = data.aws_iam_policy_document.ssm_param.json
}

resource "aws_iam_policy" "dynamodb_read" {
  name        = "${local.service}-dynamodb-read"
  description = "DynamoDB read policy for ${local.service}"
  policy      = data.aws_iam_policy_document.dynamodb_read.json
}

resource "aws_iam_policy" "dynamodb_orders_table_read" {
  name        = "${local.service}-dynamodb-orders-table-read"
  description = "DynamoDB read policy for ${local.service} DynamoDB Orders Table"
  policy      = data.aws_iam_policy_document.dynamodb_orders_table_read.json
}

resource "aws_iam_policy" "dynamodb_write" {
  name        = "${local.service}-dynamodb-write"
  description = "DynamoDB write policy for ${local.service}"
  policy      = data.aws_iam_policy_document.dynamodb_write.json
}

resource "aws_iam_policy" "dynamodb_orders_table_write" {
  name        = "${local.service}-dynamodb-orders-table-write"
  description = "DynamoDB write policy for ${local.service} DynamoDB Orders Table"
  policy      = data.aws_iam_policy_document.dynamodb_orders_table_write.json
}

resource "aws_iam_policy" "kms_use" {
  name        = "${local.service}-kms-use"
  description = "KMS usage policy for ${local.service}"
  policy      = data.aws_iam_policy_document.kms_use.json
}
