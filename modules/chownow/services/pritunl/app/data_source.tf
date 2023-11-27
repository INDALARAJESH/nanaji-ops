data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_organizations_organization" "chownow" {}

### AMI created using Packer for pritunl-app service

data "aws_ami" "cn_pritunl_app" {
  most_recent = true
  owners      = [data.aws_caller_identity.current.account_id]

  filter {
    name   = "name"
    values = ["cn-pritunl-app-*"]
  }
}

### Pritunl VPN VPC

data "aws_vpc" "pritunl_vpc" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pritunl_vpc.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["public_base"]
  }
}

data "aws_security_group" "pritunl_internal" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pritunl_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.service}-internal-${var.env}"]
  }
}

data "aws_security_group" "pritunl_allow_udp" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pritunl_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.service}-allow-udp-${var.env}"]
  }
}

data "aws_lb_target_group" "pritunl_https_tg" {
  name = "${var.service}-hosts-https-${var.env}"
}

data "aws_eip" "pritunl" {
  for_each = local.pritunl_instances

  tags = {
    Name = each.value.name
  }
}
