data "aws_ecs_task_definition" "restaurant-search-etl-manage" {
  task_definition = "${var.service}-etl-manage-${local.env}"
}

data "aws_ecs_cluster" "restaurant-search" {
  cluster_name = "${var.service}-${local.env}"
}

data "aws_vpc" "env_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "env_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.env_vpc.id]
  }

  filter {
    name   = "tag:NetworkZone"
    values = ["private_base"]
  }
}

data "aws_security_group" "ingress_security_group" {
  name = "ingress-${var.service}-${local.env}"
}

data "aws_caller_identity" "current" {}
