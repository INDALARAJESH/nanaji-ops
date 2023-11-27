module "api_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "Loyalty Service API Key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "api_key"
  service     = var.service
}

module "sfdc_integration_user" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.0"

  description = "Salesforce Integration User"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_integration_user"
  secret_key  = "token"
  service     = var.service
}

module "sfdc_integration_pass" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.0"

  description = "Salesforce Integration Password"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_integration_pass"
  secret_key  = "token"
  service     = var.service
}

module "sfdc_integration_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.0"

  description = "Salesforce Integration Security Token"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "sfdc_integration_token"
  secret_key  = "token"
  service     = var.service
}
