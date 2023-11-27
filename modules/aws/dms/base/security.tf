resource "aws_security_group" "repl_instance" {
  name        = local.repl_instance_id
  description = "replication instance for ${var.service} in ${upper(local.env)}"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "access to ${var.service}-${local.env} replication instance from inside VPC"
    from_port   = var.source_port
    to_port     = var.source_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.repl_instance_id }
  )
}
