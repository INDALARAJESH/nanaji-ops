# Placeholder secret to allow the AWS DMS endpoint resources to be created
resource "random_string" "temp_password" {
  length      = 32
  special     = false
  lower       = true
  min_lower   = 5
  upper       = true
  min_upper   = 5
  min_numeric = 5
  min_special = 0
}

module "dms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dms/base?ref=aws-dms-base-v2.0.8"

  custom_vpc_name                 = local.vpc_name
  env                             = var.env
  env_inst                        = var.env_inst
  service                         = var.service
  repl_inst_extra_security_groups = local.repl_instance_extra_security_groups
  table_mappings                  = templatefile("${path.module}/templates/hermosa-table-mapping.json", { schema_name = var.database_name })

  # Hermosa database
  source_database_name = var.database_name
  source_engine_name   = var.source_engine_name
  source_password      = random_string.temp_password.result
  source_port          = data.aws_rds_cluster.hermosa.port
  source_server_name   = data.aws_rds_cluster.hermosa.endpoint
  source_username      = var.source_server_username

  # Restaurant Search Database Migration Target database
  target_database_name         = var.database_name
  target_engine_name           = var.target_engine_name
  target_password              = random_string.temp_password.result
  target_port                  = var.target_port
  target_server_name           = var.target_server_name
  target_username              = var.target_username
  repl_instance_deploy_timeout = "60m"

  lob_max_size = var.lob_max_size

  extra_tags = {
    Owner    = var.tag_owner
    TFModule = var.tag_tfmodule
  }
}
