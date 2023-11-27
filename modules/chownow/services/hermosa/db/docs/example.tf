# Terraform (basic):
module "hermosa_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/db?ref=cn-hermosa-db-v2.2.1"
  env    = "uat"
}

# Terraform (alternate):
module "db" {
  source                          = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/db?ref=cn-hermosa-db-v2.2.1"
  env                             = var.env
  db_instance_class               = "db.r5.4xlarge"
  enable_cloudwatch_logs          = 1
  db_backup_retention_period      = 30
  db_performance_insights_enabled = true
  db_snapshot_identifier          = "arn:aws:rds:us-east-1:1234567890:snapshot:db-snapshot-20210611"
  extra_security_groups           = ["sg-09e4a6fc3243436cd"]
  menu_s3_bucket_name             = "menu-rds-data-migration-qa"
}
