data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_security_group" "internal_allow" {
  filter {
    name   = "tag:Name"
    values = ["internal-${var.env}"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.env]
  }
}

# dunno if needed. this was used in the original ec2 module
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = [local.subnet]
  }
}
