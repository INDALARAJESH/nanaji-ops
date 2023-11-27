module "lambda_sqs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.2.0"

  env                                = var.env
  env_inst                           = var.env_inst
  service                            = var.service
  lambda_iam_role_id                 = module.hermosa_lambda.lambda_iam_role_id
  sqs_queue_name                     = var.sqs_queue_name
  lambda_function_arn                = module.hermosa_lambda.lambda_function_arn
  maximum_concurrency                = var.maximum_concurrency
  function_response_types            = var.function_response_types
  mapping_batch_size                 = var.lambda_mapping_batch_size
  maximum_batching_window_in_seconds = var.lambda_maximum_batching_window_in_seconds
}

module "low_priority_lambda_sqs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.2.0"

  env                                = var.env
  env_inst                           = var.env_inst
  service                            = var.service
  lambda_iam_role_id                 = module.hermosa_low_priority_lambda.lambda_iam_role_id
  sqs_queue_name                     = "${var.low_priority_sqs_queue_name}_${local.env}"
  lambda_function_arn                = module.hermosa_low_priority_lambda.lambda_function_arn
  maximum_concurrency                = var.maximum_concurrency
  function_response_types            = var.function_response_types
  mapping_batch_size                 = var.lambda_low_priority_mapping_batch_size
  maximum_batching_window_in_seconds = var.lambda_low_priority_maximum_batching_window_in_seconds
}
