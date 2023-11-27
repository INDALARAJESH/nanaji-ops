module "configuration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = "hermosa-events configuration file"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "configuration"
  service     = var.service
}
