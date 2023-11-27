data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:VPC"
    values = [var.vpc_tag_name]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:VPC"
    values = [var.vpc_tag_name]
  }
  filter {
    name   = "tag:NetworkType"
    values = ["private"]
  }
}
