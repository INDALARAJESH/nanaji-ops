resource "aws_security_group" "interface_vpc_endpoint" {
  name   = format("%s-interface-vpc-ep-%s-sg", data.aws_vpc.selected.tags.Name, var.service_name)
  vpc_id = data.aws_vpc.selected.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = format("%s-interface-vpc-ep-%s-sg", data.aws_vpc.selected.tags.Name, var.service_name),
    }
  )
}

resource "aws_security_group_rule" "interface_vpc_endpoint_ingress_tcp_allowed" {
  type              = "ingress"
  security_group_id = aws_security_group.interface_vpc_endpoint.id
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
}

resource "aws_security_group_rule" "interface_vpc_endpoint_egress_allow_all" {
  type              = "egress"
  security_group_id = aws_security_group.interface_vpc_endpoint.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
