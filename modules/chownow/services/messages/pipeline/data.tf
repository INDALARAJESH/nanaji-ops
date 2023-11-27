data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_sns_topic" "cn_events" {
  count = var.topic_arn != "" ? 0 : 1
  name  = "${var.topic_base_name}-${local.env}"
}
