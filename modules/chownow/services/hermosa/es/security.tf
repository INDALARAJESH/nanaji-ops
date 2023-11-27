resource "aws_security_group" "es" {
  name   = local.name
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )
}

resource "aws_security_group_rule" "es_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.es.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = local.vpc_subnet_cidrs

}

resource "aws_security_group_rule" "es_egress_allowed_all" {
  type              = "egress"
  security_group_id = aws_security_group.es.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
