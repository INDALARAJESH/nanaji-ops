module "loyalty_sqs_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-image?ref=aws-lambda-image-v2.0.0"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = local.sqs_lambda_classification
  lambda_cron_boolean     = var.sqs_refresh_cron_boolean
  lambda_description      = "Loyalty SQS event entrypoint"
  lambda_env_variables    = local.sqs_lambda_env_variables
  lambda_image_config_cmd = var.sqs_lambda_image_config_cmd
  lambda_image_uri        = local.sqs_lambda_image_uri
  lambda_memory_size      = var.sqs_lambda_memory_size
  lambda_name             = var.sqs_lambda_name
  lambda_timeout          = var.sqs_lambda_timeout
  service                 = var.service
  with_lifecycle          = false

  cloudwatch_schedule_expression = var.sqs_refresh_schedule_expression
}
