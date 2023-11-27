data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

# Required to allow the replication instance to talk to hermosa's aurora database in legacy VPCs
data "aws_security_group" "internal_legacy" {
  count = local.vpc_name == var.env ? 1 : 0

  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["internal-${local.env}"]
  }
}


data "aws_rds_cluster" "hermosa" {
  cluster_identifier = var.source_db_instance_identifier
}
