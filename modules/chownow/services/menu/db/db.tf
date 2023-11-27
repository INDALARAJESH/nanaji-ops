resource "aws_rds_cluster_parameter_group" "cluster" {
  name        = "${var.service}-mysql-cluster-${local.env}"
  family      = "aurora-mysql5.7"
  description = "Aurora cluster parameter group for the ${var.service} service in ${local.env}"
  # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraMySQL.Updates.2023.html

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name         = "server_audit_events"
    value        = "CONNECT,QUERY"
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_excl_users"
    value        = "rdsadmin,svc_telegraf"
    apply_method = "immediate"
  }

  parameter {
    name         = "server_audit_logging"
    value        = "1"
    apply_method = "immediate"
  }

  parameter { # Needed to enable DMS
    name         = "binlog_row_image"
    value        = "Full"
    apply_method = "pending-reboot"
  }
  parameter { # Needed to enable DMS
    name         = "binlog_checksum"
    value        = "NONE"
    apply_method = "pending-reboot"
  }
  parameter { # Needed to enable DMS
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }
  parameter {
    name         = "aurora_load_from_s3_role"
    value        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/menu-rds-s3-role-${local.env}"
    apply_method = "immediate"
  }
  parameter {
    name         = "aurora_select_into_s3_role"
    value        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/menu-rds-s3-role-${local.env}"
    apply_method = "immediate"
  }
  parameter {
    name         = "aws_default_s3_role"
    value        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/menu-rds-s3-role-${local.env}"
    apply_method = "immediate"
  }

  tags = local.common_tags
}

resource "aws_db_parameter_group" "instance" {
  name        = "${var.service}-mysql-instance-${local.env}"
  family      = "aurora-mysql5.7"
  description = "Aurora instance parameter group for the ${var.service} service in ${local.env}"

  parameter {
    name         = "max_connections"
    value        = var.max_connections
    apply_method = "immediate"
  }

  # Required for Percona Performance Monitoring
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
    value        = 15
    apply_method = "immediate"
  }

  ### parameters required for datadog agent monitoring

  parameter {
    name         = "performance_schema"
    value        = 1
    apply_method = "pending-reboot"
  }

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


  tags = local.common_tags
}

module "menu_aurora" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/aurora/mysql?ref=aws-aurora-mysql-v2.1.2"

  env             = var.env
  env_inst        = var.env_inst
  service         = var.service
  vpc_name_prefix = var.vpc_name_prefix

  db_cluster_parameter_group_name  = aws_rds_cluster_parameter_group.cluster.name
  db_instance_parameter_group_name = aws_db_parameter_group.instance.name
  db_instance_class                = var.db_instance_class
  db_database_name                 = "menu"
  db_engine_version                = "5.7.mysql_aurora.2.11.3"
  custom_db_password               = random_password.master_password.result
  db_performance_insights_enabled  = false
}
