module "get_restaurant" {
  source = "./api_lambda"

  service                = local.service
  env                    = local.env
  api_lambda_name        = "get-restaurant"
  api_lambda_image_tag   = var.lambda_image_tag
  lambda_base_policy_arn = aws_iam_policy.lambda_base.arn
  image_repository_url   = local.image_repository_url
  api_gw_execution_arn   = aws_api_gateway_rest_api.private_api.execution_arn

  resource_path = "GET/v1/restaurants/{restaurant_id}"

  environment_variables = merge(
    {
      DYNAMODB_TABLE       = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL         = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER    = var.api_get_restaurant_lambda_command
      GSI_1_NAME           = local.db_cn_restaurant_gsi_name
      SENTRY_DSN           = aws_ssm_parameter.sentry_dsn.value
      LAUNCHDARKLY_SDK_KEY = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )
}

resource "aws_iam_role_policy_attachment" "get_restaurant_policy_attachment_dynamo_read" {
  role       = module.get_restaurant.api_lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}
