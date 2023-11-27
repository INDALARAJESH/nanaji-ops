resource "aws_security_group" "dd_agent" {
  name        = local.name
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags, { "Name" = local.name })
}
