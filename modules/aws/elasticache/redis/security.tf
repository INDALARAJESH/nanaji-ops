#########################
# Redis Security Groups #
#########################

resource "aws_security_group" "redis" {
  name   = "${var.service}-redis-sg-${local.env}"
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-redis-sg-${local.env}" }
  )
}

resource "aws_security_group_rule" "redis_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.redis.id
  from_port         = var.redis_tcp_port
  to_port           = var.redis_tcp_port
  protocol          = "tcp"
  cidr_blocks       = local.vpc_subnet_cidrs

}

resource "aws_security_group_rule" "redis_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.redis.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "redis_icmp-self" {
  security_group_id = aws_security_group.redis.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}
