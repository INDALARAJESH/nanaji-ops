data "aws_region" "current" {}


data "aws_ec2_managed_prefix_list" "pritunl_public_ips" {
  filter {
    name   = "prefix-list-name"
    values = ["pritunl-public-ip-list-ops"]
  }
}
