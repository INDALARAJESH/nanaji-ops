# Random 32 character password without special characters because of mysql limitation.
# The password is fed to the aurora cluster and AWS Secrets Manager.
resource "random_password" "master_password" {
  length  = var.password_length
  special = false
}

# Creating AWS Secret with the password created above
module "db_master_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=cn-hermosa-db-v2.2.0&depth=1"

  env                = local.env
  secret_description = "aurora master password for ${local.secret_name} in ${local.env}"
  secret_name        = local.secret_name
  secret_plaintext   = random_password.master_password.result
  service            = var.service
}
