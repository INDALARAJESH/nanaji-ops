module "es_access_key_id" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-create-v2.0.1"

  secret_description = "OpenSearch IAM access key id"
  env                = var.env
  env_inst           = var.env_inst
  secret_name        = "${local.env}/${var.service}/es_access_key_id"
  secret_plaintext   = module.search_db.aws_access_key_id
  service            = var.service
}

module "es_secret_access_key" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-create-v2.0.1"

  secret_description = "OpenSearch IAM secret access key"
  env                = var.env
  env_inst           = var.env_inst
  secret_name        = "${local.env}/${var.service}/es_secret_access_key"
  secret_plaintext   = module.search_db.aws_secret_access_key
  service            = var.service
}

module "es_access_key_id_admin_ro" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-create-v2.0.1"

  secret_description = "OpenSearch IAM access key id for administrative read-only user"
  env                = var.env
  env_inst           = var.env_inst
  secret_name        = "${local.env}/${var.service}/es_access_key_id_admin_ro"
  secret_plaintext   = module.search_db.aws_access_key_id_admin_ro
  service            = var.service
}

module "es_secret_access_key_admin_ro" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-create-v2.0.1"

  secret_description = "OpenSearch IAM secret access key administrative read-only user"
  env                = var.env
  env_inst           = var.env_inst
  secret_name        = "${local.env}/${var.service}/es_secret_access_key_admin_ro"
  secret_plaintext   = module.search_db.aws_secret_access_key_admin_ro
  service            = var.service
}
