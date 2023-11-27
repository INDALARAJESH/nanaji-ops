data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_lb" "main" {
  name = var.alb_name
}

data "aws_lb_target_group" "main" {
  name = var.target_group_name
}
