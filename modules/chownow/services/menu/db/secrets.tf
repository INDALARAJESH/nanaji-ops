# Random 32 character password without special characters because of mysql limitation.
# The password is fed to the aurora cluster and AWS Secrets Manager.
resource "random_password" "master_password" {
  length  = var.password_length
  special = false
}

resource "random_password" "user_password" {
  length  = var.password_length
  special = false
}

# Creating AWS Secret with the password created above
module "db_master_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = local.env
  secret_description = "aurora master password for ${var.service} in ${local.env}"
  secret_name        = "${local.env}/${var.service}/db_master_password"
  secret_plaintext   = random_password.master_password.result
  service            = var.service
}

module "db_user_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = local.env
  secret_description = "aurora user password for ${var.service} in ${local.env}"
  secret_name        = "${local.env}/${var.service}/db_user_password"
  secret_plaintext   = random_password.user_password.result
  service            = var.service
}
