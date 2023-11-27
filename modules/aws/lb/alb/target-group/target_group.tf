resource "aws_lb_target_group" "tg" {
  deregistration_delay = var.deregistration_delay
  name                 = local.tg_name
  port                 = var.tg_port
  protocol             = var.alb_listener_protocol
  vpc_id               = var.vpc_id
  target_type          = var.alb_tg_target_type

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
    path                = var.health_check_target
    protocol            = var.alb_listener_protocol
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.tg_name
    "ALB" = var.alb_name }
  )
}
