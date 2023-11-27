module "db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/db?ref=backstage-service-db-v2.0.1"

  env                     = var.env
  service                 = var.service
  db_password_secret_name = var.db_password_secret_name
  vpc_name_prefix         = var.vpc_name_prefix
}
