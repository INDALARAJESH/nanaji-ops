module "get_order_prices" {
  source = "./api_lambda"

  service                = local.service
  env                    = local.env
  api_lambda_name        = "get-order-prices"
  api_lambda_image_tag   = var.lambda_image_tag
  lambda_base_policy_arn = aws_iam_policy.lambda_base.arn
  image_repository_url   = local.image_repository_url
  api_gw_execution_arn   = aws_api_gateway_rest_api.private_api.execution_arn
  lambda_memory_size     = 512

  resource_path = "POST/v1/restaurants/{restaurant_id}/order_prices"

  enable_lambda_autoscaling      = var.enable_lambda_autoscaling
  lambda_provisioned_concurrency = var.lambda_provisioned_concurrency

  environment_variables = merge(
    {
      DYNAMODB_TABLE                     = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                       = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER                  = var.api_get_order_prices_lambda_command
      GSI_1_NAME                         = local.db_cn_restaurant_gsi_name
      KMS_KEY_ALIAS                      = aws_ssm_parameter.kms_key_alias.value
      TOAST_URL                          = aws_ssm_parameter.toast_url.value
      TOAST_TOKEN_PARAMETER_NAME         = local.ssm_toast_token
      TOAST_CLIENT_ID_PARAMETER_NAME     = aws_ssm_parameter.toast_client_id.name
      TOAST_CLIENT_SECRET_PARAMETER_NAME = aws_ssm_parameter.toast_client_secret.name
      TOAST_EXTERNAL_ID_PREFIX           = aws_ssm_parameter.toast_external_id_prefix.value
      SENTRY_DSN                         = aws_ssm_parameter.sentry_dsn.value
      LAUNCHDARKLY_SDK_KEY               = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )
}


resource "aws_iam_role_policy_attachment" "get_order_prices_policy_attachment_dynamo_read" {
  role       = module.get_order_prices.api_lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "get_order_prices_policy_attachment_dynamo_write" {
  role       = module.get_order_prices.api_lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}

resource "aws_iam_role_policy_attachment" "get_order_prices_policy_attachment_ssm_param" {
  role       = module.get_order_prices.api_lambda_role_name
  policy_arn = aws_iam_policy.ssm_param.arn
}

resource "aws_iam_role_policy_attachment" "get_order_prices_policy_attachment_kms_use" {
  role       = module.get_order_prices.api_lambda_role_name
  policy_arn = aws_iam_policy.kms_use.arn
}
