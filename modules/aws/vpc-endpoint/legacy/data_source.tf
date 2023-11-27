data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet_ids" "base" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_subnet_tag_value]
  }
}

data "aws_subnet" "subnet" {
  for_each = data.aws_subnet_ids.base.ids
  id       = each.value
}
