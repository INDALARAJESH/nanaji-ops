resource "aws_security_group" "alb_public" {
  name        = "${var.service}-pub-${local.env}"
  description = "Allow inbound access to public ${var.service} ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "inbound access to public ${var.service} ALB from VPN and extra external IPs"
    from_port   = var.alb_tcp_port
    to_port     = var.alb_tcp_port
    protocol    = "tcp"
    cidr_blocks = concat(data.aws_ec2_managed_prefix_list.pritunl_public_ips.entries[*].cidr, var.extra_ip_allow_list)
  }

  ingress {
    description = "inbound access to public ${var.service} ALB from inside VPC"
    from_port   = var.alb_tcp_port
    to_port     = var.alb_tcp_port
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
      "Name", "${var.service}-pub-${local.env}",
    )
  )

}
