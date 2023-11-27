resource "aws_security_group" "db" {
  name        = "${var.service}-${local.env}"
  description = "Allow inbound access to ${local.name} mysql"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "inbound access to ${local.name} from VPN and extra external"
    from_port   = var.db_tcp_port
    to_port     = var.db_tcp_port
    protocol    = "tcp"
    cidr_blocks = concat(var.vpn_ip_allow_list, var.extra_ip_allow_list)
  }

  ingress {
    description = "inbound access to ${local.name} from FiveTran"
    from_port   = var.db_tcp_port
    to_port     = var.db_tcp_port
    protocol    = "tcp"
    cidr_blocks = var.fivetran_ip_allow_list
  }

  ingress {
    description = "inbound access to ${local.name} from inside VPC"
    from_port   = var.db_tcp_port
    to_port     = var.db_tcp_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )

}
