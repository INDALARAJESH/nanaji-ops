# Simple Aurora Cluster/Database
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = "${var.service}-mysql-cluster-${local.env}"
  family      = "aurora5.6"
  description = "Aurora cluster parameter group for the ${var.service} service in ${local.env}"

}

resource "aws_db_parameter_group" "instance" {
  name        = "${var.service}-mysql-instance-${local.env}"
  family      = "aurora5.6"
  description = "Aurora instance parameter group for the ${var.service} service in ${local.env}"

}

module "hermosa_aurora" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/mysql?ref=aws-aurora-mysql-v2.1.4"

  env     = var.env
  service = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_database_name                 = "chownow"
}
# Note: The Cluster and Instance parameter group were intentionally created outside of the module for better visibility and more flexibility._

# Database Cluster from snapshot
resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = "${var.service}-mysql-cluster-${local.env}"
  family      = "aurora5.6"
  description = "Aurora cluster parameter group for the ${var.service} service in ${local.env}"

}

resource "aws_db_parameter_group" "instance" {
  name        = "${var.service}-mysql-instance-${local.env}"
  family      = "aurora5.6"
  description = "Aurora instance parameter group for the ${var.service} service in ${local.env}"

}

module "hermosa_aurora" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/mysql?ref=aws-aurora-mysql-v2.1.4"

  env     = var.env
  service = var.service

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_database_name                 = "chownow"
  db_snapshot_identifier           = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
}
# Note: any username/password/database name parameters set will be overridden by the snapshot_

# Terraform (extended example):
module "hermosa_aurora" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/mysql?ref=aws-aurora-mysql-v2.1.4"

  env     = var.env
  service = var.service

  # DB Cluster Variables
  custom_db_password              = random_password.master_password.result
  db_apply_immediately            = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.cluster.name
  db_database_name                = "chownow"
  db_engine_version               = "5.6.mysql_aurora.1.23.2"
  db_backup_retention_period      = 7
  db_snapshot_identifier          = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
  db_username                     = var.db_username

  # DB Instance Variables
  count_cluster_instances          = 3
  db_instance_class                = var.db_instance_class
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_performance_insights_enabled  = true


  # DB DNS Variables
  custom_cname_endpoint        = "db-master"   # eg. db-master.uat.aws.chownow.com
  custom_cname_endpoint_reader = "db-replica"  # eg. db-replica.uat.aws.chownow.com
}
