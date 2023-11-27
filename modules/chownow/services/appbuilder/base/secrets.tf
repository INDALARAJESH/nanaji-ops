# General Secrets

module "master_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description = "root user credentials for ${upper(var.service)} postgres database"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "pgmaster_password"
  service     = "${var.service}"
}

module "user_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v3.0.0"

  description = "${var.service} user credentials for allowing application to connect to ${upper(var.service)} postgres database"
  env         = "${var.env}"
  env_inst    = "${var.env_inst}"
  secret_name = "user_password"
  service     = "${var.service}"
}
