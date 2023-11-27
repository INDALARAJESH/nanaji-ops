module "membership_updated_sns_sqs_subscription" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/sqs-subscription?ref=aws-sns-sqs-subscription-v2.3.0"

  count         = var.sns_memberships_topic_arn != null ? 1 : 0
  sns_topic_arn = var.sns_memberships_topic_arn
  sqs_queue_arn = module.hermosa_sqs.sqs_queue_arn
  service       = var.service
  env           = var.env

  filter_policy = jsonencode({
    type = [var.membership_updated_message_type_filter]
  })

  depends_on = [module.hermosa_sqs]
}

module "order_delivery_sns_sqs_subscription" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/sqs-subscription?ref=aws-sns-sqs-subscription-v2.3.0"

  count         = var.sns_order_delivery_topic_arn != null ? 1 : 0
  sns_topic_arn = var.sns_order_delivery_topic_arn
  sqs_queue_arn = module.hermosa_sqs.sqs_queue_arn
  service       = var.service
  env           = var.env

  depends_on = [module.hermosa_sqs]
}
