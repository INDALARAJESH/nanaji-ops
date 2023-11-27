data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.selected_vpc]
  }
}
data "aws_acm_certificate" "public" {
  domain      = local.certificate_domain
  statuses    = ["ISSUED"]
  most_recent = true
}

data "aws_security_group" "vpn_sg" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = [local.selected_sg]
  }
}