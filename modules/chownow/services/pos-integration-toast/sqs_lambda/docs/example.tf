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
      DYNAMODB_TABLE    = aws_ssm_parameter.dynamodb_table.value
      DYNAMODB_URL      = aws_ssm_parameter.dynamodb_url.value
      DD_LAMBDA_HANDLER = var.webhook_partner_lambda_command
      GSI_1_NAME        = local.db_cn_restaurant_gsi_name
    },
    local.datadog_env_vars
  )
}


resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_read" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_read.arn
}

resource "aws_iam_role_policy_attachment" "partner_policy_attachment_dynamo_write" {
  role       = module.partner.lambda_handler_role_name
  policy_arn = aws_iam_policy.dynamodb_write.arn
}
