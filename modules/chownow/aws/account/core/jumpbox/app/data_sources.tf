data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "cn_jumpbox" {
  most_recent = true
  owners      = [data.aws_caller_identity.current.account_id]

  filter {
    name   = "name"
    values = ["cn-jumpbox-*"]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

# Teleport Data Source lookup
data "aws_iam_policy" "teleport_dynamic_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/teleport-dynamic-${var.env}"
}

data "aws_iam_policy" "teleport_connect_policy" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/teleport-connect-${var.env}"
}
