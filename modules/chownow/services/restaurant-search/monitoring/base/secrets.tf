module "dd_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "DataDog app key"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "datadog/${var.service}-app_key"
  service     = var.service
}
