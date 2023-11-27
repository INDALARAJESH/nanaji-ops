###############
# General AWS #
###############
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


#######
# ALB #
#######

data "aws_lb_target_group" "selected" {
  name = "${var.service}-pub-${local.env}-${var.container_port}"
}


#######
# VPC #
#######

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name_prefix}-${local.env}"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:NetworkZone"
    values = [var.vpc_private_subnet_tag_key]
  }
}


###############
# ECS Cluster #
###############

data "aws_ecs_cluster" "selected" {
  cluster_name = local.cluster_name
}

#######
# ECR #
#######
# data "aws_ecr_repository" "selected" {
#   name = var.service
# }
