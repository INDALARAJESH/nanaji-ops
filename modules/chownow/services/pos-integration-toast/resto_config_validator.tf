module "resto_config_validator" {
  source                           = "./scheduled_lambda"
  service                          = local.service
  env                              = local.env
  lambda_name                      = "resto-config-validator"
  lambda_image_tag                 = var.lambda_image_tag
  lambda_base_policy_arn           = aws_iam_policy.lambda_base.arn
  image_repository_url             = local.image_repository_url
  event_bridge_schedule_expression = "rate(60 minutes)"
  lambda_timeout                   = 900

  environment_variables = merge(
    {
      DYNAMODB_TABLE                                              = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                                                = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER                                           = var.resto_config_validator_command
      GSI_1_NAME                                                  = local.db_cn_restaurant_gsi_name
      MENUS_EVENT_QUEUE_NAME                                      = aws_ssm_parameter.menus_event_queue_name.value
      KMS_KEY_ALIAS                                               = aws_ssm_parameter.kms_key_alias.value
      TOAST_URL                                                   = aws_ssm_parameter.toast_url.value
      TOAST_TOKEN_PARAMETER_NAME                                  = local.ssm_toast_token
      TOAST_CLIENT_ID_PARAMETER_NAME                              = aws_ssm_parameter.toast_client_id.name
      TOAST_CLIENT_SECRET_PARAMETER_NAME                          = aws_ssm_parameter.toast_client_secret.name
      SLACK_CONFIGURATION_NOTIFICATION_WEBHOOK_URL_PARAMETER_NAME = aws_ssm_parameter.slack_configuration_notification_webhook_url.name
      ENABLE_SLACK_NOTIFICATIONS_PARAMETER_NAME                   = aws_ssm_parameter.enable_slack_notifications.name
      HERMOSA_ADMIN_BASE_URL                                      = aws_ssm_parameter.hermosa_admin_base_url.value
      LAUNCHDARKLY_SDK_KEY                                        = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )
}

resource "aws_iam_role_policy_attachment" "resto_config_validator_policy_attachment_dynamo_read" {
  role       = module.resto_config_validator.lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "resto_config_validator_policy_attachment_ssm_param" {
  role       = module.resto_config_validator.lambda_role_name
  policy_arn = aws_iam_policy.ssm_param.arn
}

resource "aws_iam_role_policy_attachment" "resto_config_validator_policy_attachment_kms_use" {
  role       = module.resto_config_validator.lambda_role_name
  policy_arn = aws_iam_policy.kms_use.arn
}
