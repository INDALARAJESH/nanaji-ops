module "menu_metadata_checker" {
  source                           = "./scheduled_lambda"
  service                          = local.service
  env                              = local.env
  lambda_name                      = "menu-metadata-checker"
  lambda_image_tag                 = var.lambda_image_tag
  lambda_base_policy_arn           = aws_iam_policy.lambda_base.arn
  image_repository_url             = local.image_repository_url
  event_bridge_schedule_expression = "rate(30 minutes)"

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
    },
    local.datadog_env_vars
  )
}
