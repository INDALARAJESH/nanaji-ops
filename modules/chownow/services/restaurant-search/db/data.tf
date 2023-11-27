data "aws_caller_identity" "current" {}

data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.private.id

  tags = {
    NetworkType = "private"
  }
}
