module "publish_from_sns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-platform-app-v2.0.0"

  count = var.enable_publish_from_sns

  env            = var.env
  env_inst       = var.env_inst
  service        = "publish-from-sns"
  sns_topic_name = "publish-from-sns-${local.env}"

  extra_tags = local.extra_tags
}
