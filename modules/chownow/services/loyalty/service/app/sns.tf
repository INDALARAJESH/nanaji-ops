module "memberships-sns-topic" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.3"

  env            = local.env
  service        = var.service
  sns_topic_name = "cn-membership-events-${local.env}"

  sns_cross_account_access_arn = var.sns_cross_account_access_arn
}
