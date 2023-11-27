resource "random_string" "secret" {
  length      = 32
  special     = false
  lower       = true
  min_lower   = 5
  upper       = true
  min_upper   = 5
  min_numeric = 5
  min_special = 0
}

module "orderetl_dms" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dms/base?ref=aws-dms-base-v2.0.5"

  custom_vpc_name                 = local.vpc_name
  env                             = var.env
  service                         = var.service
  repl_inst_extra_security_groups = [data.aws_security_group.internal_legacy.id]
  table_mappings                  = templatefile("${path.module}/templates/hermosa-table-mapping.json", { schema_name = var.database_name })

  source_database_name = var.database_name
  source_engine_name   = data.aws_rds_cluster.hermosa.engine
  source_password      = random_string.secret.result
  source_port          = data.aws_rds_cluster.hermosa.port
  source_server_name   = data.aws_rds_cluster.hermosa.endpoint
  source_username      = var.source_server_username

  target_database_name = var.database_name
  target_engine_name   = var.target_engine_name
  target_password      = random_string.secret.result
  target_port          = var.target_port
  target_server_name   = var.target_server_name
  target_username      = var.target_username

  extra_tags = {
    Owner    = var.tag_owner
    TFModule = var.tag_tfmodule
  }

}
