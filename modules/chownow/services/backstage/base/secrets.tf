module "github_oauth_app_client_id" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  env         = var.env
  description = "Github OAuth App Client Id used as an Authentication Provider"
  secret_name = var.github_oauth_app_client_id_secret_name
  service     = var.service
}

module "github_oauth_app_client_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  env         = var.env
  description = "Github OAuth App Client Secret used as an Authentication Provider"
  secret_name = var.github_oauth_app_client_secret_name
  service     = var.service
}

module "github_catalog_integration_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  env         = var.env
  description = "Github App credentials used for catalog discovery"
  secret_name = var.github_catalog_integration_secret_name
  secret_key  = "app_id"
  service     = var.service
}

module "jenkins_api_key_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  env         = var.env
  description = "Jenkins api key used for integration"
  secret_name = var.jenkins_api_key_secret_name
  service     = var.service
}
