data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_security_group" "integrations" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["integrations-postgres-${local.env}"]
  }
}

data "aws_db_instance" "integrations" {
  db_instance_identifier = var.source_db_instance_identifier
}
