module "mul_slack_notifications_dlq" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.2"

  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.service}-slack-dlq-${local.env}"
  visibility_timeout_seconds = 30
}

module "mul_slack_notifications_queue" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.2"

  depends_on                 = [module.mul_slack_notifications_dlq]
  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.service}-slack-${local.env}"
  visibility_timeout_seconds = 30
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.mul_slack_notifications_dlq.sqs_queue_arn
    maxReceiveCount     = 3
  })
}

module "mul_notifications_slack_sqs_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/lambda_mapping?ref=aws-sqs-lambda_mapping-v2.0.0"

  depends_on           = [module.mul_notifications_slack_lambda]
  env                  = var.env
  env_inst             = var.env_inst
  service              = var.service
  lambda_iam_role_id   = module.mul_notifications_slack_lambda.lambda_iam_role_id
  mapping_batch_size   = 1
  sqs_queue_name       = module.mul_slack_notifications_queue.sqs_queue_name
  lambda_function_name = module.mul_notifications_slack_lambda.lambda_function_name
}
