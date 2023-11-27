data "aws_acm_certificate" "star_chownow" {
  domain      = local.app_domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_ec2_managed_prefix_list" "pritunl_public_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["pritunl-public-ip-list-ops"]
  }
}

data "aws_vpc" "private" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}
