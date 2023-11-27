module "sqs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.0.1"

  env                        = local.env
  service                    = var.service
  sqs_queue_name             = var.sqs_queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
}
