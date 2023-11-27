data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

data "aws_security_group" "dms" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["dms-postgres-${local.env}"]
  }
}

data "aws_rds_cluster" "dms" {
  cluster_identifier = var.source_db_cluster_identifier
}
