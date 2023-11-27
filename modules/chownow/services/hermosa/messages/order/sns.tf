module "sns_order" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.3"

  env                                     = local.env
  service                                 = var.service
  sns_topic_name                          = local.sns_topic_name
  sns_lambda_success_feedback_sample_rate = var.sns_lambda_success_feedback_sample_rate
  sns_cross_account_access_arn            = var.sns_cross_account_access_arn
}
