
data "aws_caller_identity" "current" {}


#######
# AMI #
#######
data "aws_ami" "datavail" {
  owners      = [data.aws_caller_identity.current.account_id]
  most_recent = true

  filter {
    name   = "tag:Service"
    values = [var.service]
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.custom_vpc_name]
  }
}

data "aws_security_group" "ingress_vpn_allow" {
  filter {
    name   = "tag:Name"
    values = [local.ingress_vpn_sg]
  }
}

data "aws_route53_zone" "chownow_dot_com" {

  count = var.enable_a_record == 1 && local.env == "prod" ? 1 : 0

  name = "${var.domain}."
}
