data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_lb" "admin" {
  name = var.admin_alb_name
}

data "aws_lb_listener" "admin" {
  load_balancer_arn = data.aws_lb.admin.arn
  port              = 443
}

data "aws_lb" "api" {
  name = var.api_alb_name
}

data "aws_lb_listener" "api" {
  load_balancer_arn = data.aws_lb.api.arn
  port              = 443
}

data "aws_lb" "webhook" {
  count = var.enable_webhook ? 1 : 0
  name  = var.webhook_alb_name
}

data "aws_lb_listener" "webhook" {
  count             = var.enable_webhook ? 1 : 0
  load_balancer_arn = data.aws_lb.webhook[0].arn
  port              = 443
}

data "aws_lb_target_group" "admin_blue" {
  name = var.target_group_admin_blue
}

data "aws_lb_target_group" "admin_ck_blue" {
  name = var.target_group_admin_ck_blue
}

data "aws_lb_target_group" "api_blue" {
  name = var.target_group_api_blue
}

data "aws_lb_target_group" "webhook_blue" {
  count = var.enable_webhook ? 1 : 0
  name  = var.target_group_webhook_blue
}

data "aws_lb_target_group" "admin_green" {
  name = var.target_group_admin_green
}

data "aws_lb_target_group" "admin_ck_green" {
  name = var.target_group_admin_ck_green
}

data "aws_lb_target_group" "api_green" {
  name = var.target_group_api_green
}

data "aws_lb_target_group" "webhook_green" {
  count = var.enable_webhook ? 1 : 0
  name  = var.target_group_webhook_green
}
