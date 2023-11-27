module "sqs_success_queue" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.0"

  env            = local.env
  service        = var.service
  sqs_queue_name = format("%s-success-queue-%s", var.name, local.env)
}

module "sqs_failure_queue" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.0"

  env            = local.env
  service        = var.service
  sqs_queue_name = format("%s-failure-queue-%s", var.name, local.env)
}
