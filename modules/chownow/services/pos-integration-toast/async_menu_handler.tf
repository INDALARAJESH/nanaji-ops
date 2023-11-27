# Menu Sync Component
#
# Lambda and SQS configuration for handling events around menu syncing and ingestion
module "menu" {
  source                   = "./sqs_lambda"
  service                  = local.service
  env                      = local.env
  sqs_queue_name           = "menu-sync"
  handler_name             = "menu-sync"
  handler_lambda_image_tag = var.lambda_image_tag
  lambda_base_policy_arn   = aws_iam_policy.lambda_base.arn
  image_repository_url     = local.image_repository_url

  lambda_memory_size         = 512
  lambda_timeout             = 240
  visibility_timeout_seconds = 1440

  environment_variables = merge(
    {
      DYNAMODB_TABLE                                     = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                                       = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER                                  = var.webhook_menu_lambda_command
      GSI_1_NAME                                         = local.db_cn_restaurant_gsi_name
      HERMOSA_ADMIN_BASE_URL                             = aws_ssm_parameter.hermosa_admin_base_url.value
      HERMOSA_URL                                        = aws_ssm_parameter.hermosa_url.value
      HERMOSA_API_KEY_PARAMETER_NAME                     = aws_ssm_parameter.hermosa_api_key.name
      KMS_KEY_ALIAS                                      = aws_ssm_parameter.kms_key_alias.value
      SLACK_MENU_NOTIFICATION_WEBHOOK_URL_PARAMETER_NAME = aws_ssm_parameter.slack_menu_notification_webhook_url.name
      ENABLE_SLACK_NOTIFICATIONS_PARAMETER_NAME          = aws_ssm_parameter.enable_slack_notifications.name
      MENUS_EVENT_QUEUE_NAME                             = aws_ssm_parameter.menus_event_queue_name.value
      TOAST_URL                                          = aws_ssm_parameter.toast_url.value
      TOAST_TOKEN_PARAMETER_NAME                         = local.ssm_toast_token
      TOAST_CLIENT_ID_PARAMETER_NAME                     = aws_ssm_parameter.toast_client_id.name
      TOAST_CLIENT_SECRET_PARAMETER_NAME                 = aws_ssm_parameter.toast_client_secret.name
      SENTRY_DSN                                         = aws_ssm_parameter.sentry_dsn.value
      LAUNCHDARKLY_SDK_KEY                               = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )

  # vpc configuration as this lambda needs access to the Hermosa API
  lambda_vpc_subnet_ids     = var.lambda_vpc_subnet_ids
  lambda_security_group_ids = var.lambda_vpc_id != "" ? [aws_security_group.lambda[0].id] : []
}


resource "aws_iam_role_policy_attachment" "menu_policy_attachment_dynamo_read" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "menu_policy_attachment_dynamo_write" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}

resource "aws_iam_role_policy_attachment" "menu_policy_attachment_ssm_param" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = aws_iam_policy.ssm_param.arn
}

resource "aws_iam_role_policy_attachment" "menu_policy_attachment_kms_use" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = aws_iam_policy.kms_use.arn
}

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-permissions
resource "aws_iam_role_policy_attachment" "menu_lambda_vpc" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "menu_sync_event_queue_policy" {
  name   = "${local.service}-lambda-menu-sync-sqs-${var.env}"
  policy = data.aws_iam_policy_document.menu_sync_event_queue_policy_doc.json
}

data "aws_iam_policy_document" "menu_sync_event_queue_policy_doc" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage", "sqs:GetQueueUrl", "sqs:GetQueueAttributes"]
    resources = [module.menu.queue_arn]
  }
}

resource "aws_iam_role_policy_attachment" "menu_sync_event_sqs" {
  role       = module.menu.lambda_handler_role_name
  policy_arn = aws_iam_policy.menu_sync_event_queue_policy.arn
}
