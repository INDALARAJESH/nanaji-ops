module "menu_metadata_checker" {
  source                           = "./scheduled_lambda"
  service                          = local.service
  env                              = local.env
  lambda_name                      = "menu-metadata-checker"
  lambda_image_tag                 = var.lambda_image_tag
  lambda_base_policy_arn           = aws_iam_policy.lambda_base.arn
  image_repository_url             = local.image_repository_url
  event_bridge_schedule_expression = "rate(30 minutes)"
  lambda_timeout                   = 900

  environment_variables = merge(
    {
      DYNAMODB_TABLE                     = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                       = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER                  = var.menu_metadata_checker_command
      GSI_1_NAME                         = local.db_cn_restaurant_gsi_name
      MENUS_EVENT_QUEUE_NAME             = aws_ssm_parameter.menus_event_queue_name.value
      KMS_KEY_ALIAS                      = aws_ssm_parameter.kms_key_alias.value
      TOAST_URL                          = aws_ssm_parameter.toast_url.value
      TOAST_TOKEN_PARAMETER_NAME         = local.ssm_toast_token
      TOAST_CLIENT_ID_PARAMETER_NAME     = aws_ssm_parameter.toast_client_id.name
      TOAST_CLIENT_SECRET_PARAMETER_NAME = aws_ssm_parameter.toast_client_secret.name
      SENTRY_DSN                         = aws_ssm_parameter.sentry_dsn.value
      LAUNCHDARKLY_SDK_KEY               = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )
}

resource "aws_iam_role_policy_attachment" "menu_metadata_checker_policy_attachment_dynamo_read" {
  role       = module.menu_metadata_checker.lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "menu_metadata_checker_policy_attachment_ssm_param" {
  role       = module.menu_metadata_checker.lambda_role_name
  policy_arn = aws_iam_policy.ssm_param.arn
}

resource "aws_iam_role_policy_attachment" "menu_metadata_checker_policy_attachment_kms_use" {
  role       = module.menu_metadata_checker.lambda_role_name
  policy_arn = aws_iam_policy.kms_use.arn
}

data "aws_iam_policy_document" "menus_queue_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "sqs:SendMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
    ]
    resources = [module.menu.queue_arn]
  }
}

resource "aws_iam_policy" "menus_queue_policy" {
  name   = "${local.service}-lambda-menu-metadata-checker-sqs-${var.env}"
  policy = data.aws_iam_policy_document.menus_queue_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "menu_metadata_checker_policy_attachment_sqs" {
  role       = module.menu_metadata_checker.lambda_role_name
  policy_arn = aws_iam_policy.menus_queue_policy.arn
}

