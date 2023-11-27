#######
# AMI #
#######
data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

##############
# Networking #
##############

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:${var.subnet_tag_filter}" # defaults to NetworkZone
    values = [var.subnet_tag]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}


#######
# DNS #
#######

data "aws_route53_zone" "private" {
  count = var.enable_dns_record_private == 1 && local.env != "prod" ? 1 : 0

  vpc_id       = data.aws_vpc.selected.id
  name         = "${local.dns_zone_private}."
  private_zone = var.private_zone_boolean
}

data "aws_route53_zone" "public" {
  count = local.env != "prod" ? 1 : 0

  name = "${local.dns_zone_public}."
}
