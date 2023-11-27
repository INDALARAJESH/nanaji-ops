module "internal_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  custom_sg_name          = "internal-${var.env}${var.env_inst}"
  description             = "VPC security group with internal access."
  env                     = var.env
  env_inst                = var.env_inst
  service                 = var.service
  name_prefix             = "internal"
  vpc_id                  = data.aws_vpc.selected.id
  enable_egress_allow_all = 1
  ingress_custom_allowed  = [0]
  ingress_custom_protocol = "-1"
  ingress_custom_self     = true
}

module "vpn_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  custom_sg_name = "vpn-${var.env}${var.env_inst}"
  description    = "Allows ping, ssh, and munin for VPN clients"
  env            = var.env
  env_inst       = var.env_inst
  service        = var.service
  name_prefix    = "vpn"
  vpc_id         = data.aws_vpc.selected.id

  ingress_tcp_allowed = ["22"]
  cidr_blocks         = var.vpn_subnets

  ingress_custom_allowed  = [-1]
  ingress_custom_protocol = "icmp"
}

module "vpn_web_sg" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/security-group/basic?ref=aws-sg-basic-v2.0.1"

  custom_sg_name = "vpn_web-${var.env}${var.env_inst}"
  description    = "Allow web connections from the VPN subnet"
  env            = var.env
  env_inst       = var.env_inst
  service        = var.service
  name_prefix    = "vpn_web"
  vpc_id         = data.aws_vpc.selected.id

  ingress_tcp_allowed = ["80", "443"]
  cidr_blocks         = concat(var.vpn_subnets, [data.aws_vpc.selected.cidr_block])
}

resource "aws_security_group" "db" {
  name        = "db-${var.env}${var.env_inst}"
  description = "Access for RDS instances"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [module.internal_sg.id]
  }

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [module.internal_sg.id]
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
      "Name", "db-${var.env}${var.env_inst}",
    )
  )
}
