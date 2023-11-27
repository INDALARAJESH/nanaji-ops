data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:VPC"
    values = [local.vpc_name]
  }

  tags = {
    NetworkZone = var.vpc_private_subnet_tag_key
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:VPC"
    values = [local.vpc_name]
  }

  tags = {
    NetworkZone = var.vpc_public_subnet_tag_key
  }
}

locals {
  vpc_name = var.custom_vpc_name != "" ? var.custom_vpc_name : "${var.vpc_name_prefix}-${local.env}"

}
