module "rds_postgres" {
  source                     = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.1.3"
  db_backup_retention_period = 7
  env                        = var.env
  service                    = var.service
  db_username                = var.db_username
  vpc_name_prefix            = var.vpc_name_prefix
  db_engine_version          = "11.16"
}
