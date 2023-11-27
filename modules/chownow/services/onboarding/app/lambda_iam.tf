### Lambda Policy
### Lambda Execution Role -- https://docs.aws.amazon.com/lambda/latest/dg/lambda-intro-execution-role.html

data "aws_iam_policy_document" "lambda" {
  statement {
    sid    = "secret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue"
    ]
    resources = [
      format(
        "arn:aws:secretsmanager:%s:%s:secret:%s/%s/*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.env,
        local.app_name
      ),
      format(
        "%s*", data.aws_secretsmanager_secret.dd_api_key.arn
      )
    ]
  }

  statement {
    sid    = "DynamoDB"
    effect = "Allow"
    actions = [
      "dynamodb:*",
    ]
    resources = [
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.schedule_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.schedule_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.menu_link_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.menu_link_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.assets_upload_url_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.assets_upload_url_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.salesforce_client_cache_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.salesforce_client_cache_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.progress_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.progress_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.website_access_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.website_access_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.promotion_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.promotion_table_name}/index/*",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.onboarding_table_name}",
      "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.onboarding_table_name}/index/*",
    ]
  }

  statement {
    sid    = "XRay"
    effect = "Allow"
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3Objects"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:::${local.onboarding_files_s3_bucket_name}/*",
    ]
  }

  statement {
    sid    = "S3Bucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${local.onboarding_files_s3_bucket_name}",
    ]
  }
}

resource "aws_iam_policy" "lambda" {
  name        = format("%s-lambda", local.app_name)
  path        = format("/lambda_policies/%s/", local.app_name)
  description = format("Policy to give %s specific functionality", local.app_name)
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "api_gateway_event_handler_lambda" {
  role       = module.api_gateway_event_handler_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_role_policy_attachment" "presigned_url_lambda" {
  role       = module.presigned_url_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_role_policy_attachment" "event_bridge_event_handler_lambda" {
  role       = module.event_bridge_event_handler_lambda.lambda_iam_role_name
  policy_arn = aws_iam_policy.lambda.arn
}
