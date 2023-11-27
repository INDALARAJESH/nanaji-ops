module "restaurant_search_sns_subscription_sqs" {
  source     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/sqs-subscription?ref=aws-sns-sqs-subscription-v2.0.1"
  depends_on = [module.restaurant_search_etl_kickoff_queue]

  sns_topic_name = "${var.sns_topic_base_name}-${local.env}"
  sqs_queue_name = module.restaurant_search_etl_kickoff_queue.sqs_queue_name
  service        = var.service
  env            = var.env

  filter_policy = jsonencode({
    type = [var.restaurant_updated_message_type_filter]
  })
}
