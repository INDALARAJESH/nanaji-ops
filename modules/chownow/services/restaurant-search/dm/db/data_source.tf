data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = ["public_base"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_route53_zone" "public" {
  name = "${local.env}.${var.svpn_subdomain}.${var.domain}."
}

data "aws_ec2_managed_prefix_list" "pritunl_public_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["pritunl-public-ip-list-ops"]
  }
}
