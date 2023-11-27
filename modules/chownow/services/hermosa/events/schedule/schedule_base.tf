module "schedule_base" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/eventbridge/schedule-base?ref=aws-eventbridge-schedule-base-v2.0.2"
  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  target_sqs_queue_name = var.target_sqs_queue_name
}
