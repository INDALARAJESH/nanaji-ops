module "sns_order" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.1"

  env                                     = local.env
  fifo_topic                              = var.enable_sns_fifo_topic
  service                                 = var.service
  sns_topic_name                          = local.sns_topic_name
  sns_lambda_success_feedback_sample_rate = var.sns_lambda_success_feedback_sample_rate
}
