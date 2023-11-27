module "tenable_api_token" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description = "${local.service} user credentials for allowing application to connect to ${upper(local.service)} tenable"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "api"
  service     = local.service
}
