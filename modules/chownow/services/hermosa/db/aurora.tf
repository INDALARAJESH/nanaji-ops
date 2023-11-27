###########################
# Aurora Parameter Groups #
###########################
resource "aws_rds_cluster_parameter_group" "cluster_param_group_57" {
  name        = local.cluster_parameter_group_name
  family      = var.db_parameter_family
  description = "RDS cluster parameter group for hermosa aurora"

  # This is required to support AWS DMS
  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "server_audit_events"
    value        = "CONNECT,QUERY"
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_excl_users"
    value        = "rdsadmin,svc_telegraf,${var.db_username}"
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_logging"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "aurora_load_from_s3_role"
    value        = local.rds_s3_role_name
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "aurora_select_into_s3_role"
    value        = local.rds_s3_role_name
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "aws_default_s3_role"
    value        = local.rds_s3_role_name
    apply_method = "pending-reboot"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

resource "aws_db_parameter_group" "db_param_group_57" {
  name        = local.db_parameter_group
  family      = var.db_parameter_family
  description = "RDS database parameter group for hermosa aurora"

  # Required for Percona Performance Monitoring
  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_monitor_enable"
    value        = "all"
    apply_method = "immediate"
  }

  # Enable Slow Query Log
  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_output"
    value        = "FILE"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "long_query_time"
    value        = var.db_long_query_time
    apply_method = "immediate"
  }

  parameter {
    name         = "sql_mode"
    value        = var.sql_mode
    apply_method = "immediate"
  }

  parameter {
    name         = "interactive_timeout"
    value        = var.interactive_timeout
    apply_method = "immediate"
  }

  parameter {
    name         = "wait_timeout"
    value        = var.wait_timeout
    apply_method = "immediate"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = var.max_allowed_packet
    apply_method = "immediate"
  }

  parameter {
    name         = "table_open_cache"
    value        = var.table_open_cache
    apply_method = "immediate"
  }

  parameter {
    name         = "sort_buffer_size"
    value        = var.sort_buffer_size
    apply_method = "immediate"
  }

  parameter {
    name         = "max_heap_table_size"
    value        = var.max_heap_table_size
    apply_method = "immediate"
  }

  parameter {
    name         = "tmp_table_size"
    value        = var.tmp_table_size
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_stats_persistent_sample_pages"
    value        = var.innodb_stats_persistent_sample_pages
    apply_method = "immediate"
  }

  ### parameters required for datadog agent monitoring

  parameter {
    name         = "performance_schema_consumer_events_statements_current"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance-schema-consumer-events-waits-current"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_statements_history"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_statements_history_long"
    value        = 1
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_max_digest_length"
    value        = 4096
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_max_sql_text_length"
    value        = 4096
    apply_method = "pending-reboot"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.common_tags
}

##################
# Aurora Cluster #
##################
module "db_cluster" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/mysql?ref=cn-hermosa-db-v2.2.1&depth=1"

  env                       = var.env
  env_inst                  = var.env_inst
  service                   = var.service
  custom_vpc_name           = var.custom_vpc_name
  custom_name               = var.custom_name
  custom_cluster_identifier = var.custom_cluster_identifier
  vpc_subnet_tag_value      = var.vpc_subnet_tag_value

  # DB Cluster Variables
  custom_db_password                     = random_password.master_password.result
  db_apply_immediately                   = var.db_apply_immediately
  db_cluster_parameter_group_name        = aws_rds_cluster_parameter_group.cluster_param_group_57.name
  db_database_name                       = var.db_database_name
  db_engine                              = var.db_engine
  db_engine_version                      = var.db_engine_version
  db_backup_retention_period             = var.db_backup_retention_period
  db_snapshot_identifier                 = var.db_snapshot_identifier
  db_username                            = var.db_username
  db_allow_major_version_upgrade         = var.db_allow_major_version_upgrade
  db_iam_database_authentication_enabled = var.db_iam_database_authentication_enabled

  # DB Instance Variables
  count_cluster_instances          = var.count_cluster_instances
  db_instance_class                = var.db_instance_class
  db_instance_parameter_group_name = aws_db_parameter_group.db_param_group_57.name
  db_performance_insights_enabled  = var.db_performance_insights_enabled
  db_security_group_ids            = local.db_security_groups

  # DB DNS Variables
  custom_cname_endpoint        = var.db_cname_endpoint
  custom_cname_endpoint_reader = var.db_cname_endpoint_reader
  private_dns_zone             = var.private_dns_zone
  dns_zone_name                = local.dns_zone_name
}
