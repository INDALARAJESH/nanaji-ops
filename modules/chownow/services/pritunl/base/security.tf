### SG for Pritunl hosts, MongoDB hosts, and Pritunl ALB

resource "aws_security_group" "pritunl_internal" {
  name        = "${var.service}-internal-${local.env}"
  description = "Allow all traffic between Pritunl resources and allow all egress"
  vpc_id      = data.aws_vpc.pritunl_vpc.id

  ingress {
    description = "Allow all ingress from this SG"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = true
  }

  egress {
    description      = "Allow all egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-internal-${local.env}",
    )
  )
}

### SG for Pritunl hosts to accept VPC traffic

resource "aws_security_group" "pritunl_allow_udp" {
  name        = "${var.service}-allow-udp-${local.env}"
  description = "Allow UDP traffic for VPN connections"
  vpc_id      = data.aws_vpc.pritunl_vpc.id

  ingress {
    description = "Allow UDP traffic for VPN connections"
    from_port   = 18107
    to_port     = 18107
    protocol    = "udp"
    cidr_blocks = var.vpn_udp_allowed_sources
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-allow-udp-${local.env}",
    )
  )
}

### SG for Pritunl ALB to accept web traffic from Pritunl public IPs

resource "aws_security_group" "pritunl_alb_web_vpn" {
  name        = "${var.service}-allow-vpn-web-${local.env}"
  description = "Allow web traffic to Pritunl ALB from Pritunl public IPs"
  vpc_id      = data.aws_vpc.pritunl_vpc.id

  ingress {
    description = "Allow HTTP traffic to ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.pritunl_app0.public_ip}/32", "${aws_eip.pritunl_app1.public_ip}/32"]
  }

  ingress {
    description = "Allow HTTPS traffic to ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.pritunl_app0.public_ip}/32", "${aws_eip.pritunl_app1.public_ip}/32"]
  }

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-allow-vpn-web-${local.env}",
    )
  )
}

### SG for Pritunl ALB to accept Cloudflare web traffic

resource "aws_security_group" "pritunl_alb_web_cloudflare" {
  name        = "${var.service}-allow-cloudflare-web-${local.env}"
  description = "Allow Cloudflare web traffic to Pritunl ALB"
  vpc_id      = data.aws_vpc.pritunl_vpc.id

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-allow-cloudflare-web-${local.env}",
    )
  )
}

resource "aws_security_group_rule" "cloudflare_ips" {
  for_each          = { for entry in data.aws_ec2_managed_prefix_list.cloudflare_ips.entries : entry.cidr => entry }
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [each.key]
  security_group_id = aws_security_group.pritunl_alb_web_cloudflare.id
}


resource "aws_key_pair" "pritunl_ssh_key" {
  key_name   = "${var.service}-${local.env}"
  public_key = local.pritunl_pub_key

  tags = merge(
    local.common_tags,
    map(
      "Name", "${var.service}-${local.env}",
    )
  )
}
