resource "random_password" "pgmaster_password" {
  count = local.create_pgmaster_password

  length  = 32
  special = false
}

resource "aws_db_instance" "db" {
  allocated_storage          = var.db_allocated_storage
  apply_immediately          = var.db_apply_immediately
  auto_minor_version_upgrade = var.db_auto_minor_version_upgrade
  backup_retention_period    = var.db_backup_retention_period
  backup_window              = var.db_backup_window
  ca_cert_identifier         = var.db_ca_cert_identifier
  db_subnet_group_name       = aws_db_subnet_group.db.id
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  identifier                 = local.name
  instance_class             = var.db_instance_class
  maintenance_window         = var.db_maintenance_window
  multi_az                   = var.db_multi_az
  parameter_group_name       = aws_db_parameter_group.db.name
  password                   = local.pgmaster_password
  publicly_accessible        = var.db_publicly_accessible
  skip_final_snapshot        = var.db_skip_final_snapshot
  storage_encrypted          = var.db_storage_encrypted
  storage_type               = var.db_storage_type
  username                   = var.db_username
  vpc_security_group_ids     = [aws_security_group.db.id]

  performance_insights_enabled          = var.db_performance_insights_enabled
  performance_insights_kms_key_id       = var.db_performance_insights_kms_key_id
  performance_insights_retention_period = var.db_performance_insights_retention_period
  iam_database_authentication_enabled   = var.db_iam_database_authentication_enabled


  # rsm: temp change to ignore these sizes while we migrate them all to 334GB
  # see: https://chownow.slack.com/archives/C038ER4B4TS/p1651692589140699
  lifecycle {
    ignore_changes = [allocated_storage]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

resource "aws_db_subnet_group" "db" {
  name        = local.name
  description = "${local.env} subnet group for RDS."
  subnet_ids  = data.aws_subnet_ids.base.ids

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = local.name
    },
  )
}

######################
# DNS CNAME Creation #
######################
resource "aws_route53_record" "private_record_db_master" {
  zone_id = data.aws_route53_zone.aws.zone_id
  name    = "${var.service}-${var.db_name_suffix}.${local.env}.aws.${var.domain}." # eg. dms-master.qa.aws.chownow.com.
  type    = var.dns_record_type
  ttl     = var.dns_record_ttl
  records = ["${aws_db_instance.db.address}."]

  lifecycle {
    ignore_changes = [records] # This will be updated out-of-band via API during DB refreshes
  }
}
