data "aws_region" "current" {}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag_name]
  }
}

data "aws_route_tables" "all_route_tables" {
  vpc_id = data.aws_vpc.selected.id
}

data "aws_iam_policy_document" "gateway_vpce" {
  statement {
    sid       = "AllowAll"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}
