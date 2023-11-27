data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_security_group" "internal_allow" {
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}
