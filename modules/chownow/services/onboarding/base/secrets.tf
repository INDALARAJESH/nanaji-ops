# Runbook on updating and/or rotating these secrets:
# https://chownow.atlassian.net/wiki/spaces/MOB/pages/2805006762/Updating+SFDC+Secrets+and+Credentials

module "sfdc_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Sales Force Bearer Token"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_token"   # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name # local.service
}

module "sfdc_client_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Sales Force client secret"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_client_secret" # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name       # local.service
}

module "sfdc_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Sales Force password"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_password" # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.app_name  # local.service
}
