module "restaurant_search_etl_kickoff_dlq" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.2"

  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.service}-kickoff-dlq"
  visibility_timeout_seconds = 30
}

module "restaurant_search_etl_kickoff_queue" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.2"

  depends_on                 = [module.restaurant_search_etl_kickoff_dlq]
  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.service}-kickoff"
  visibility_timeout_seconds = 30
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.restaurant_search_etl_kickoff_dlq.sqs_queue_arn
    maxReceiveCount     = 3
  })
}

module "restaurant_search_kickoff_sqs_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.0.0"

  depends_on           = [module.restaurant_search_etl_kickoff_lambda]
  env                  = var.env
  env_inst             = var.env_inst
  service              = var.service
  lambda_iam_role_id   = module.restaurant_search_etl_kickoff_lambda.lambda_iam_role_id
  mapping_batch_size   = 1
  sqs_queue_name       = module.restaurant_search_etl_kickoff_queue.sqs_queue_name
  lambda_function_name = module.restaurant_search_etl_kickoff_lambda.lambda_function_name
}
