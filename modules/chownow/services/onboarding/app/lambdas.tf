module "api_gateway_event_handler_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.service}-${local.api_gateway_event_handler_lambda_name}-${lower(local.env)}"
  lambda_cron_boolean     = var.lambda_cron
  lambda_image_config_cmd = var.lambda_handler
  lambda_description      = "Handles API Gateway events"
  lambda_ecr              = var.lambda_ecr
  lambda_image_uri        = var.api_gateway_event_handler_image_uri
  lambda_memory_size      = 1024 # Determined by using lambda-power-tuning
  lambda_runtime          = var.lambda_runtime
  lambda_s3               = var.lambda_s3
  service                 = var.service
  lambda_timeout          = 300
  lambda_env_variables = merge(
    local.lambda_env_variables_common,
    local.api_gateway_event_handler_lambda_env_variables
  )
}

module "presigned_url_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.service}-${local.presigned_url_lambda_name}-${lower(local.env)}"
  lambda_cron_boolean     = var.lambda_cron
  lambda_image_config_cmd = var.lambda_handler
  lambda_description      = "Handler after S3 objects are created."
  lambda_ecr              = var.lambda_ecr
  lambda_image_uri        = var.presigned_url_lambda_image_uri
  lambda_memory_size      = 1024 # Determined by using lambda-power-tuning
  lambda_runtime          = var.lambda_runtime
  lambda_s3               = var.lambda_s3
  service                 = var.service
  lambda_timeout          = 300
  lambda_env_variables = merge(
    local.lambda_env_variables_common,
    local.presigned_url_lambda_env_variables
  )
}

resource "aws_lambda_permission" "allow_onboarding_files_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.presigned_url_lambda.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.onboarding_files_bucket.arn
}

resource "aws_s3_bucket_notification" "onboarding_files_bucket_notification" {
  bucket = local.onboarding_files_s3_bucket_name

  lambda_function {
    lambda_function_arn = module.presigned_url_lambda.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_onboarding_files_bucket]
}

module "event_bridge_event_handler_lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/lambda/basic?ref=aws-lambda-basic-v2.0.6"

  env                     = local.env
  extra_tags              = local.extra_tags
  lambda_classification   = "${var.service}-${local.event_bridge_event_handler_lambda_name}-${lower(local.env)}"
  lambda_cron_boolean     = var.lambda_cron
  lambda_image_config_cmd = var.lambda_handler
  lambda_description      = "Handles events from AWS AppFlow."
  lambda_ecr              = var.lambda_ecr
  lambda_image_uri        = var.event_bridge_event_handler_image_uri
  lambda_memory_size      = 1024 # TODO: Determine by using lambda-power-tuning
  lambda_runtime          = var.lambda_runtime
  lambda_s3               = var.lambda_s3
  service                 = var.service
  lambda_timeout          = 300
  lambda_env_variables = merge(
    local.lambda_env_variables_common,
    local.event_bridge_event_handler_lambda_env_variables
  )
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.event_bridge_event_handler_lambda.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sfdc_appflow_event_rule.arn
}

locals {
  api_gateway_event_handler_lambda_name  = "api-gateway-event-handler"
  presigned_url_lambda_name              = "presigned-url"
  event_bridge_event_handler_lambda_name = "event-bridge-event-handler"
}
