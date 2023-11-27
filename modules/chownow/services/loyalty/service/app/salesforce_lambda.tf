module "loyalty_salesforce_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/lambda-image?ref=aws-lambda-image-v2.0.0"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = local.salesforce_lambda_classification
  lambda_cron_boolean     = var.salesforce_lambda_cron_boolean
  lambda_description      = "Loyalty Salesforce Lambda"
  lambda_env_variables    = local.salesforce_lambda_env_variables
  lambda_image_config_cmd = var.salesforce_lambda_image_config_cmd
  lambda_image_uri        = local.salesforce_lambda_image_uri
  lambda_memory_size      = var.salesforce_lambda_memory_size
  lambda_name             = var.salesforce_lambda_name
  lambda_timeout          = var.salesforce_lambda_timeout
  service                 = var.service
  with_lifecycle          = false

  cloudwatch_schedule_expression = var.salesforce_cloudwatch_schedule_expression
}
