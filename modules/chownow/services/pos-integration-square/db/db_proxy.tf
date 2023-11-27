module "rds_proxy" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/proxy?ref=rds-proxy-v2.0.0"

  env             = var.env
  env_inst        = var.env_inst
  service         = local.service
  vpc_name_prefix = var.vpc_name_prefix

  secrets = {
    "posuser" = {
      arn = module.rds_db_details.secret_arn
    }
  }

  # Target PostgreSQL Instance
  db_engine_family      = "POSTGRESQL"
  target_db_cluster     = true
  db_cluster_identifier = module.rds_aurora_postgresql.cluster_id
}
