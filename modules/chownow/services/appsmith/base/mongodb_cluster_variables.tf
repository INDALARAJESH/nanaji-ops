locals {
  vpc_name = "main-${var.env}"

  mongodb_instances = {
    mongodb0 = {
      name          = "${var.service}-mongodb0-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[0]
    }
    mongodb1 = {
      name          = "${var.service}-mongodb1-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[1]
    }
    mongodb2 = {
      name          = "${var.service}-mongodb2-${var.env}"
      instance_type = "t3.small"
      subnet_id     = data.aws_subnets.private.ids[2]
    }
  }
}
