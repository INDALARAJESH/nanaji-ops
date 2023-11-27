resource "aws_db_subnet_group" "db" {
  name       = local.name
  subnet_ids = data.aws_subnet_ids.public.ids
}

resource "random_string" "db_password" {
  length      = 32
  special     = false
  lower       = true
  min_lower   = 5
  upper       = true
  min_upper   = 5
  min_numeric = 5
  min_special = 0
}

###################
# Target Database #
###################

resource "aws_db_parameter_group" "db" {
  name   = local.name
  family = "${var.db_engine}${var.db_engine_version}"


  # `binlog_format` must be set to `ROW` for AWS DMS to work properly
  parameter {
    name  = "binlog_format"
    value = "ROW"
  }

}
resource "aws_db_instance" "db" {
  apply_immediately                     = var.db_apply_immediately
  allocated_storage                     = var.db_allocated_storage
  backup_retention_period               = var.db_backup_retention_period
  backup_window                         = var.db_backup_window
  db_subnet_group_name                  = aws_db_subnet_group.db.id
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  engine                                = var.db_engine
  engine_version                        = var.db_engine_version
  instance_class                        = var.db_instance_class
  identifier                            = local.name
  maintenance_window                    = var.db_maintenance_window
  max_allocated_storage                 = var.db_max_allocated_storage
  monitoring_interval                   = var.db_monitoring_interval
  multi_az                              = var.db_multi_az
  password                              = random_string.db_password.result
  parameter_group_name                  = aws_db_parameter_group.db.id
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  port                                  = var.db_tcp_port
  publicly_accessible                   = var.db_publicly_accessible
  skip_final_snapshot                   = var.db_skip_final_snapshot
  storage_encrypted                     = var.db_storage_encrypted
  storage_type                          = var.db_storage_type
  username                              = var.db_username
  iam_database_authentication_enabled   = var.db_iam_database_authentication_enabled
  vpc_security_group_ids                = concat([aws_security_group.db.id], var.extra_security_groups)

  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", local.name,
    )
  )

  lifecycle {
    ignore_changes = [engine_version, name, username, password]
  }
}


output "endpoint" {
  value = aws_db_instance.db.endpoint
}

output "mysql_pw" {
  value = random_string.db_password.result
}

######################
# DNS CNAME Creation #
######################
resource "aws_route53_record" "db_public_record" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.service}-${var.db_name_suffix}.${local.env}.${var.svpn_subdomain}.${var.domain}." # eg. restaurant-search-dm-mysql.qa.svpn.chownow.com
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_db_instance.db.address}."]

}
