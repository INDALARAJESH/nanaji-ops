module "mul_2fa_sns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.2"

  env            = local.env
  service        = var.service
  sns_topic_name = "${var.service}-2fa-${var.env}"
}

# email subscription module causes a destroy and recreate every time, so not using for now.
resource "aws_sns_topic_subscription" "sns-topic" {
  topic_arn     = module.mul_2fa_sns.arn
  protocol      = "email"
  endpoint      = var.mul_2fa_email
  filter_policy = <<EOF
  {
    "recipient_email": ["${var.mul_2fa_email}"]
  }
  EOF
}
