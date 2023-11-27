resource "aws_db_parameter_group" "db" {
  name   = local.name
  family = var.db_parameter_group_family

  parameter {
    apply_method = "immediate"
    name         = "rds.log_retention_period"
    value        = "1440"
  }

  parameter {
    apply_method = "immediate"
    name         = "log_statement"
    value        = var.log_statement
  }

  parameter {
    apply_method = "immediate"
    name         = "log_min_duration_statement"
    value        = var.log_min_duration_statement
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "log_duration"
    value        = "1"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "shared_preload_libraries"
    value        = var.shared_preload_libraries
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "track_activity_query_size"
    value        = var.track_activity_query_size
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "pg_stat_statements.track"
    value        = var.pg_stat_statements_track
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "autovacuum"
    value        = "1"
  }

  parameter {
    apply_method = "immediate"
    name         = "autovacuum_naptime"
    value        = var.autovacuum_naptime
  }

  parameter {
    apply_method = "immediate"
    name         = "autovacuum_vacuum_scale_factor"
    value        = "0.2"
  }

  parameter {
    apply_method = "immediate"
    name         = "autovacuum_vacuum_threshold"
    value        = var.autovacuum_vacuum_threshold
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "log_autovacuum_min_duration"
    value        = var.log_autovacuum_min_duration
  }

  parameter {
    apply_method = "immediate"
    name         = "maintenance_work_mem"
    value        = "768000"
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "max_connections"
    value        = var.max_connections
  }

  parameter {
    apply_method = "immediate"
    name         = "standard_conforming_strings"
    value        = var.standard_conforming_strings
  }

  parameter {
    apply_method = "immediate"
    name         = "work_mem"
    value        = var.work_mem
  }

  parameter {
    apply_method = "pending-reboot"
    name         = "rds.logical_replication"
    value        = var.rds_logical_replication
  }

  parameter {
    apply_method = "immediate"
    name         = "wal_sender_timeout"
    value        = var.wal_sender_timeout
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}
