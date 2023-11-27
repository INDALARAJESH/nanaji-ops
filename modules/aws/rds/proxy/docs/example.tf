module "rds_proxy" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/proxy?ref=rds-proxy-v2.0.0"

  env             = local.env
  service         = local.service
  vpc_name_prefix = var.vpc_name_prefix

  secrets = {
    "root" = {
      arn = module.rds_proxy_credentials_insert.secret_arn
    }
  }

  # Target PostgreSQL Instance
  db_engine_family       = "POSTGRESQL"
  target_db_instance     = true
  db_instance_identifier = module.rds_postgres.db_id

  # Optional ingress security ids
  ingress_source_security_group_id = data.aws_security_group.bastion.id
}
