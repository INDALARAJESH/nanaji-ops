#######################
# ECS Security Groups #
#######################

resource "aws_security_group" "ecs_service_app" {
  name   = format("%s-ecs-service-sg-%s", local.service, local.env)
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-ecs-service-sg-%s", local.service, local.env),
    )
  )
}

resource "aws_security_group_rule" "app_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.ecs_service_app.id
  from_port         = "0"
  to_port           = "0"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "app_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_service_app.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_icmp-self" {
  security_group_id = aws_security_group.ecs_service_app.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}
