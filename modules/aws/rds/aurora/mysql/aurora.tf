resource "aws_db_subnet_group" "db" {
  name        = local.name
  description = "Aurora cluster for the ${var.service} service in ${local.env}"
  subnet_ids  = data.aws_subnets.base.ids

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.name }
  )
}

resource "random_password" "master_password" {
  length  = var.password_length
  special = false
}


resource "aws_rds_cluster" "db" {
  apply_immediately                = var.cluster_apply_immediately
  availability_zones               = local.vpc_azs
  cluster_identifier               = local.cluster_identifier
  database_name                    = var.db_database_name
  db_cluster_parameter_group_name  = var.db_cluster_parameter_group_name
  db_instance_parameter_group_name = var.db_instance_parameter_group_name
  db_subnet_group_name             = aws_db_subnet_group.db.name
  enabled_cloudwatch_logs_exports  = var.db_enabled_cloudwatch_logs_exports
  engine                           = var.db_engine
  engine_mode                      = var.db_engine_mode
  engine_version                   = var.db_engine_version
  master_username                  = var.db_username
  master_password                  = local.db_password
  port                             = var.db_tcp_port
  snapshot_identifier              = var.db_snapshot_identifier
  storage_encrypted                = var.db_storage_encrypted
  vpc_security_group_ids           = concat(var.db_security_group_ids, [aws_security_group.db.id])

  backup_retention_period             = var.db_backup_retention_period
  preferred_backup_window             = var.db_backup_window
  preferred_maintenance_window        = var.db_maintenance_window
  skip_final_snapshot                 = var.db_skip_final_snapshot
  deletion_protection                 = var.db_deletion_protection
  allow_major_version_upgrade         = var.db_allow_major_version_upgrade
  iam_database_authentication_enabled = var.db_iam_database_authentication_enabled


  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.cluster_identifier }
  )

  lifecycle {
    ignore_changes = [
      database_name,
      master_username,
      master_password,
      storage_encrypted,
      availability_zones,
      cluster_identifier,
      engine,
      engine_version
    ]
  }

}


resource "aws_rds_cluster_instance" "db" {
  count = var.count_cluster_instances

  apply_immediately            = var.db_apply_immediately
  auto_minor_version_upgrade   = var.db_auto_minor_version_upgrade
  ca_cert_identifier           = var.db_ca_cert_identifier
  cluster_identifier           = aws_rds_cluster.db.id
  engine                       = aws_rds_cluster.db.engine
  engine_version               = aws_rds_cluster.db.engine_version
  identifier                   = "${local.cluster_identifier}-${count.index}"
  instance_class               = var.db_instance_class
  monitoring_interval          = local.db_monitoring_interval
  monitoring_role_arn          = local.db_monitoring_role_arn
  performance_insights_enabled = var.db_performance_insights_enabled
  db_parameter_group_name      = var.db_instance_parameter_group_name


  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.cluster_identifier}-${count.index}" }
  )

  lifecycle {
    ignore_changes = [cluster_identifier, identifier, engine, engine_version]
  }

}
