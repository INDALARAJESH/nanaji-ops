module "pgmaster_password" {
  source             = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"
  env                = var.env
  is_kv              = false
  secret_description = "Root user credentials for ${upper(local.service)} postgres database"
  secret_name        = "${var.env}/${local.service}/pgmaster_password"
  secret_plaintext   = module.rds_postgres.pgmaster_password
  service            = local.service
}

module "postgres_password" {
  source      = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"
  description = "${local.service} user credentials for allowing application to connect to ${upper(local.service)} postgres database"
  env         = var.env
  env_inst    = var.env_inst
  secret_name = "postgres_password"
  service     = local.service
}

module "redis_authtoken" {
  source             = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"
  env                = var.env
  is_kv              = false
  secret_description = "Auth token for ${upper(local.service)} redis"
  secret_name        = "${var.env}/${local.service}/redis_auth_token"
  secret_plaintext   = module.ec_redis.auth_token
  service            = local.service
}

module "secret_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description        = "${upper(local.service)} application secret key"
  env                = var.env
  env_inst           = var.env_inst
  secret_name        = "secret_key"
  service            = local.service
  string_min_special = 4
}
