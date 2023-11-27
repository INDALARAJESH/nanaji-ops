data "aws_vpc" "selected" {

  filter {
    name   = "tag:Name"
    values = [var.service_consumer_vpc_name]
  }
}

data "aws_subnets" "consumer_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_subnet" "consumer_private" {
  for_each = toset(data.aws_subnets.consumer_private.ids)
  id       = each.value
}
