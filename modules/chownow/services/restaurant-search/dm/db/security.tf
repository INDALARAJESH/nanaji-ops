resource "aws_security_group" "db" {
  name        = "${var.service}-${local.env}"
  description = "Allow inbound access to ${local.name} mysql"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "inbound access to ${local.name} from VPN and extra external"
    from_port   = var.db_tcp_port
    to_port     = var.db_tcp_port
    protocol    = "tcp"
    cidr_blocks = concat(data.aws_ec2_managed_prefix_list.pritunl_public_ips.entries[*].cidr, var.jenkins_ip_allow_list, var.extra_ip_allow_list)
  }

  ingress {
    description = "inbound access to ${local.name} from inside VPC"
    from_port   = var.db_tcp_port
    to_port     = var.db_tcp_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    description = "outbound access from ${local.name} to inside VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.vpc_private_subnet_cidrs
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )

}
