resource "aws_lb" "ecs_orchestrator_agent" {
  name               = local.ecs_service_name
  internal           = true
  load_balancer_type = "network"
  ip_address_type    = "ipv4"
  subnets            = local.subnets

  tags = local.common_tags
}

resource "aws_lb_target_group" "ecs_orchestrator_agent" {
  name                 = local.ecs_service_name
  port                 = var.orchestrator_port
  protocol             = "TCP"
  target_type          = "ip"
  deregistration_delay = 60
  vpc_id               = local.vpc_id

  tags = local.common_tags
}

resource "aws_lb_listener" "ecs_orchestrator_agent" {
  load_balancer_arn = aws_lb.ecs_orchestrator_agent.arn
  port              = var.orchestrator_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_orchestrator_agent.arn
  }

  tags = local.common_tags
}
