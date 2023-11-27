// Read pgmaster_password from SecretsManager
module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.0.1"

  db_backup_retention_period = 7
  env                        = "dev"
  pgmaster_secret_name       = "${var.env}/${var.service}/pgmaster_password"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}

// Create pgmaster_password
module "postgresql" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/rds/postgresql?ref=rds-pg-v2.0.1"

  db_backup_retention_period = 7
  env                        = "dev"
  service                    = "dms"
  vpc_name_prefix            = "nc"
}
