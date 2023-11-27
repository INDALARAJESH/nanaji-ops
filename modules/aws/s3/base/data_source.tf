data "aws_caller_identity" "current" {}

data "aws_elb_service_account" "account" {
  count = var.create_bucket && var.attach_lb_log_delivery_policy ? 1 : 0
}
