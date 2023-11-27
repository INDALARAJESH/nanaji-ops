module "base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/base?ref=backstage-service-base-v2.0.1"

  env                                    = var.env
  service                                = var.service
  github_catalog_integration_secret_name = var.github_catalog_integration_secret_name
  github_oauth_app_client_id_secret_name = var.github_oauth_app_client_id_secret_name
  github_oauth_app_client_secret_name    = var.github_oauth_app_client_secret_name
}
