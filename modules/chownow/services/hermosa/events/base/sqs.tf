module "hermosa_sqs_dlq" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.2.0"

  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.sqs_queue_name}-dlq"
  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
}

module "hermosa_sqs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.2.0"

  env            = local.env
  depends_on     = [module.hermosa_sqs_dlq]
  service        = var.service
  sqs_queue_name = var.sqs_queue_name
  fifo_queue     = var.fifo_queue_enabled
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.hermosa_sqs_dlq.sqs_queue_arn
    maxReceiveCount     = var.max_receive_count
  })

  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  custom_queue_policy_json = local.has_custom_standard_queue_policy ? data.aws_iam_policy_document.custom_standard_queue_policy[0].json : null
}

module "hermosa_sqs_low_priority_dlq" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.2.0"

  env                        = local.env
  service                    = var.service
  sqs_queue_name             = "${var.sqs_low_priority_queue_name}-dlq"
  visibility_timeout_seconds = var.dlq_visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
}

module "hermosa_low_priority_sqs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.2.0"

  env            = local.env
  depends_on     = [module.hermosa_sqs_low_priority_dlq]
  service        = var.service
  sqs_queue_name = var.sqs_low_priority_queue_name
  fifo_queue     = var.fifo_queue_enabled
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.hermosa_sqs_low_priority_dlq.sqs_queue_arn
    maxReceiveCount     = var.max_receive_count
  })

  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.low_priority_visibility_timeout_seconds
}
