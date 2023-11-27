module "app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/app?ref=backstage-service-app-v2.0.1"

  env                     = var.env
  service                 = var.service
  db_instance_identifier  = var.db_instance_identifier
  image_repo              = var.image_repo
  image_tag               = var.image_tag
  alb_access_logs_enabled = var.alb_access_logs_enabled
  vpc_name_prefix         = var.vpc_name_prefix

  # secrets
  db_password_secret_name                = var.db_password_secret_name
  github_catalog_integration_secret_name = var.github_catalog_integration_secret_name
  github_oauth_app_client_id_secret_name = var.github_oauth_app_client_id_secret_name
  github_oauth_app_client_secret_name    = var.github_oauth_app_client_secret_name

  providers = {
    aws = aws
  }
}
