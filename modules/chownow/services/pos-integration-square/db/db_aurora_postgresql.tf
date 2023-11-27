module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = local.service

  db_backup_retention_period       = var.rds_backup_retention_period
  db_instance_class                = var.rds_instance_class
  db_engine_version                = "13.6"
  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_database_name                 = format("pos_square")

  cluster_apply_immediately = var.rds_cluster_apply_immediately
  db_apply_immediately      = var.rds_instance_apply_immediately

  vpc_name_prefix                  = var.vpc_name_prefix
}

resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-cluster-%s", local.service, local.env),
    )
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    map(
      "Name", format("%s-postgresql-instance-%s", local.service, local.env),
    )
  )
}
