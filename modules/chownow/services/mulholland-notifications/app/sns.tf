module "mul_notifications_sns_topic" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.2"

  env            = local.env
  service        = var.service
  sns_topic_name = "${var.service}-${local.env}"
}

module "mul_notifications_slack_sns_subscription" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/sqs-subscription?ref=aws-sns-sqs-subscription-v2.0.1"

  depends_on     = [module.mul_slack_notifications_queue]
  service        = var.service
  env            = var.env
  sns_topic_name = module.mul_notifications_sns_topic.name
  sqs_queue_name = module.mul_slack_notifications_queue.sqs_queue_name
  filter_policy  = <<EOF
{
  "target": ["${var.slack_target}"]
}
EOF
}
