resource "aws_db_parameter_group" "db" {
  name   = local.name
  family = "mysql5.7"

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
    apply_method = "immediate"
  }

  parameter {
    name         = "long_query_time"
    value        = 15
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
  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )
}
