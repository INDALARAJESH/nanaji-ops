#######################
# VPN Security Groups #
#######################

resource "aws_security_group" "vpc_vpn" {
  name   = "${var.vpc_name_prefix}-vpn-sg-${local.env}"
  vpc_id = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.vpc_name_prefix}-vpn-sg-${local.env}" }
  )
}

resource "aws_security_group_rule" "vpn_ingress_tcp_allowed" {
  count             = length(var.vpn_ingress_tcp_allowed)
  type              = "ingress"
  security_group_id = aws_security_group.vpc_vpn.id
  from_port         = element(var.vpn_ingress_tcp_allowed, count.index)
  to_port           = element(var.vpn_ingress_tcp_allowed, count.index)
  protocol          = "tcp"
  cidr_blocks       = concat(data.aws_ec2_managed_prefix_list.pritunl_public_ips.entries[*].cidr, var.jenkins_subnets, var.extra_allowed_subnets)
}

resource "aws_security_group_rule" "vpc_vpn_icmp" {
  security_group_id = aws_security_group.vpc_vpn.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1
  self              = true
}

output "vpc_vpn_security_group_id" {
  value = aws_security_group.vpc_vpn.id
}


##############
# Cloudflare #
##############


resource "aws_security_group" "vpc_cloudflare" {
  name   = "allow-cloudflare-ips-${var.vpc_name_prefix}-${local.env}"
  vpc_id = aws_vpc.mod.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "allow-cloudflare-ips-${var.vpc_name_prefix}-${local.env}" }
  )
}

resource "aws_security_group_rule" "cloudflare_ingress_tcp_allowed" {
  count             = length(var.cloudflare_ingress_tcp_allowed)
  type              = "ingress"
  security_group_id = aws_security_group.vpc_cloudflare.id
  from_port         = element(var.cloudflare_ingress_tcp_allowed, count.index)
  to_port           = element(var.cloudflare_ingress_tcp_allowed, count.index)
  protocol          = "tcp"
  cidr_blocks       = var.cloudflare_subnets
}
