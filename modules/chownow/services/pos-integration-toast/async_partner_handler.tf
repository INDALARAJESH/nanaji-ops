# Partner Component
#
# Lambda and SQS configuration for handling partner events
module "partner" {
  source                   = "./sqs_lambda"
  service                  = local.service
  env                      = local.env
  sqs_queue_name           = "partner"
  fifo_queue               = true
  handler_name             = "partner"
  handler_lambda_image_tag = var.lambda_image_tag
  lambda_base_policy_arn   = aws_iam_policy.lambda_base.arn
  image_repository_url     = local.image_repository_url

  environment_variables = merge(
    {
      DYNAMODB_TABLE                 = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL                   = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER              = var.webhook_partner_lambda_command
      GSI_1_NAME                     = local.db_cn_restaurant_gsi_name
      HERMOSA_URL                    = aws_ssm_parameter.hermosa_url.value
      HERMOSA_API_KEY_PARAMETER_NAME = aws_ssm_parameter.hermosa_api_key.name
      KMS_KEY_ALIAS                  = aws_ssm_parameter.kms_key_alias.value
      SENTRY_DSN                     = aws_ssm_parameter.sentry_dsn.value
      LAUNCHDARKLY_SDK_KEY           = data.aws_secretsmanager_secret_version.launch_darkly_sdk_key.arn
    },
    local.datadog_env_vars
  )

  # vpc configuration as this lambda needs access to the Hermosa API
  lambda_vpc_subnet_ids     = var.lambda_vpc_subnet_ids
  lambda_security_group_ids = var.lambda_vpc_id != "" ? [aws_security_group.lambda[0].id] : []
}


resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_read" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_write" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}

resource "aws_iam_role_policy_attachment" "partner_policy_attachment_ssm_param" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.ssm_param.arn
}

resource "aws_iam_role_policy_attachment" "partner_policy_attachment_kms_use" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.kms_use.arn
}

# https://docs.aws.amazon.com/lambda/latest/dg/configuration-vpc.html#vpc-permissions
resource "aws_iam_role_policy_attachment" "partner_lambda_vpc" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
