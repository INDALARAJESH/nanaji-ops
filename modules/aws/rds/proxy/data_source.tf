// Networking

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [format("%s-%s", var.vpc_name_prefix, local.env)]
  }
}

data "aws_subnet_ids" "base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [format("%s_base", var.subnet_tag)]
  }
}

data "aws_subnet_ids" "subnet" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkType"
    values = [var.subnet_tag]
  }
}

data "aws_subnet" "subnet" {
  count = length(data.aws_subnet_ids.subnet.ids)
  id    = tolist(data.aws_subnet_ids.subnet.ids)[count.index]
}

# data "aws_route53_zone" "aws" {
#   vpc_id       = data.aws_vpc.selected.id
#   name         = "${local.env}.aws.${var.domain}."
#   private_zone = var.is_private
# }
