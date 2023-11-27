data "aws_security_group" "internal" {
  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}
