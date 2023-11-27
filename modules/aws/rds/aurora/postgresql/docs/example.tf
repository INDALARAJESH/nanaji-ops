/*
 * NOTE: DB ENGINE VERSION AND PARAMETER GROUPS FAMILY MUST HAVE THE MATCHING MAJOR VERSION:
 * -- db_engine_version == 12.10 && family == aurora-postgresql12
 * -- db_engine_version == 13.6 && family == aurora-postgresql13
 */

/*
 * Simple Aurora Cluster/Database:
 */

/*
 * Note: The Cluster and Instance parameter group were intentionally created outside of the module
 * for better visibility and more flexibility.
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    { "Name" = format("%s-postgresql-cluster-%s", local.service, local.env )},
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    { "Name" = format("%s-postgresql-instance-%s"
local.service = local.env },
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_engine_version                = "13.6"
  db_database_name                 = "chownow"
}

/*
 * Database Cluster from snapshot:
 */

/*
 * _Note: any username/password/database name parameters set will be overridden by the snapshot_
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql13"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    { "Name" = format("%s-postgresql-cluster-%s"
local.service = local.env },
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
    { "Name" = format("%s-postgresql-instance-%s"
local.service = local.env },
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_engine_version                = "13.6"
  db_database_name                 = "chownow"
  db_snapshot_identifier           = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
}


/*
 * Terraform (extended example):
 */
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = format("%s-postgresql-cluster-%s", local.service, local.env)
  family      = "aurora-postgresql12"
  description = format("Aurora cluster parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    { "Name" = format("%s-postgresql-cluster-%s"
local.service = local.env },
    )
  )
}

resource "aws_db_parameter_group" "instance" {
  name        = format("%s-postgresql-instance-%s", local.service, local.env)
  family      = "aurora-postgresql12"
  description = format("Aurora instance parameter group for the %s service in %s", local.service, local.env)
  tags = merge(
    local.common_tags,
    local.extra_tags,
    { "Name" = format("%s-postgresql-instance-%s"
local.service = local.env },
    )
  )
}

module "rds_aurora_postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/postgresql?ref=aws-aurora-postgresql-v2.0.2"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  # DB Cluster Variables
  custom_db_password              = random_password.master_password.result
  db_apply_immediately            = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster.name
  db_database_name                = "chownow"
  db_engine_version               = "12.10"
  db_backup_retention_period      = 7
  db_snapshot_identifier          = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
  db_username                     = var.db_username

  # DB Instance Variables
  count_cluster_instances          = 2
  db_instance_class                = var.db_instance_class
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_performance_insights_enabled  = true

  # DB DNS Variables
  custom_cname_endpoint        = "db-master"  # eg. db-master.uat.aws.chownow.com
  custom_cname_endpoint_reader = "db-replica" # eg. db-replica.uat.aws.chownow.com
}
