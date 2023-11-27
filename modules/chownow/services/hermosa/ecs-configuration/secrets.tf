module "ssl_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description           = "hermosa nginx ssl key"
  env                   = var.env
  env_inst              = var.env_inst
  secret_name           = "ssl_key"
  service               = local.service
  enable_secret_version = 0
}

module "ssl_cert" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description           = "hermosa nginx ssl certificate"
  env                   = var.env
  env_inst              = var.env_inst
  secret_name           = "ssl_cert"
  service               = local.service
  enable_secret_version = 0
}

module "configuration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.2"

  description           = "hermosa configuration file"
  env                   = var.env
  env_inst              = var.env_inst
  secret_name           = "configuration"
  service               = local.service
  enable_secret_version = 0
}
