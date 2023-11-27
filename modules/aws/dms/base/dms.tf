############################
# DMS Replication Instance #
############################

resource "aws_dms_replication_subnet_group" "mitm" {
  replication_subnet_group_description = "${var.service}-${local.env} replication instance subnet group"
  replication_subnet_group_id          = local.repl_instance_id
  subnet_ids                           = data.aws_subnet_ids.private_base.ids

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.repl_instance_id }
  )

}
resource "aws_dms_replication_instance" "mitm" { # Man In The Middle
  allocated_storage           = var.repl_inst_allocated_storage
  apply_immediately           = var.repl_inst_apply_immediately
  auto_minor_version_upgrade  = var.repl_inst_auto_minor_version_upgrade
  engine_version              = var.repl_inst_engine_version
  multi_az                    = var.repl_inst_multi_az
  publicly_accessible         = var.repl_inst_publicly_accessible
  replication_instance_class  = var.repl_inst_instance_class
  replication_instance_id     = local.repl_instance_id
  replication_subnet_group_id = aws_dms_replication_subnet_group.mitm.id

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.repl_instance_id }
  )

  vpc_security_group_ids = concat(var.repl_inst_extra_security_groups, [aws_security_group.repl_instance.id])

  depends_on = [aws_security_group.repl_instance]

  timeouts {
    create = var.repl_instance_deploy_timeout
    delete = var.repl_instance_deploy_timeout
  }
}


#################
# DMS Endpoints #
#################
resource "aws_dms_certificate" "cert" {
  certificate_id  = "cert-${var.service}-${local.env}"
  certificate_pem = file("${path.module}/files/rds-combined-ca-bundle.pem")

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "cert-${var.service}-${local.env}" }
  )

}

resource "aws_dms_endpoint" "source" {
  database_name               = var.source_database_name
  endpoint_id                 = "source-${var.source_database_name}-${var.service}-${local.env}"
  endpoint_type               = "source"
  engine_name                 = var.source_engine_name == "aurora-mysql" ? "aurora" : var.source_engine_name
  password                    = var.source_password
  port                        = var.source_port
  server_name                 = var.source_server_name
  ssl_mode                    = var.source_ssl_mode
  username                    = var.source_username
  extra_connection_attributes = var.source_extra_connection_attributes

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "source-${var.source_database_name}-${var.service}-${local.env}" }
  )

  lifecycle {
    ignore_changes = [password, username]
  }
}

resource "aws_dms_endpoint" "target" {
  certificate_arn = aws_dms_certificate.cert.certificate_arn
  database_name   = var.target_database_name
  endpoint_id     = "target-${var.target_database_name}-${var.service}-${local.env}"
  endpoint_type   = "target"
  engine_name     = var.target_engine_name
  password        = var.target_password
  port            = var.target_port
  server_name     = var.target_server_name
  ssl_mode        = var.target_ssl_mode
  username        = var.target_username

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "target-${var.target_database_name}-${var.service}-${local.env}" }
  )

  lifecycle {
    ignore_changes = [password, username]
  }
}



############
# DMS task #
############

resource "aws_dms_replication_task" "sync" {

  migration_type            = var.migration_type
  replication_instance_arn  = aws_dms_replication_instance.mitm.replication_instance_arn
  replication_task_id       = "sync-${var.source_database_name}-${var.service}-${local.env}"
  replication_task_settings = local.repl_task_settings
  source_endpoint_arn       = aws_dms_endpoint.source.endpoint_arn
  table_mappings            = var.table_mappings
  target_endpoint_arn       = aws_dms_endpoint.target.endpoint_arn

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "sync-${var.source_database_name}-${var.service}-${local.env}" }
  )

  lifecycle {
    ignore_changes = [replication_task_settings] # needed otherwise it will trigger a change when you initiate the first sync
  }

}
