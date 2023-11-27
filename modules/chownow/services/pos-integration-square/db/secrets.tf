module "pgmaster_password" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  env_inst           = var.env_inst
  is_kv              = false
  secret_description = format("Root user credentials for %s postgres database", upper(local.service))
  secret_name        = format("%s/%s/%s", var.env, local.service, "pgmaster_password")
  secret_plaintext   = module.rds_aurora_postgresql.pgmaster_password
  service            = local.service
}

# This secret should follow the json structure as defined in the documentation:
# https://docs.aws.amazon.com/secretsmanager/latest/userguide/reference_secret_json_structure.html#reference_secret_json_structure_rds-postgres
# {
#  "engine": "postgresql+psycopg2",
#  "host": "<instance host name/resolvable DNS name>",
#  "username": "<username>",
#  "password": "<password>",
#  "dbname": "<database name. If not specified, defaults to 'postgres'>",
#  "port": "<TCP port number. If not specified, defaults to 5432>"
# }
module "rds_db_details" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/create?ref=aws-secrets-create-v2.0.1"

  description = format("Non-root user credentials - Amazon RDS PostgreSQL secret structure (JSON) -- ie: {engine:postgresql+psycopg2, host:<db_host>, username:<db_user>, password:<db_pass>, dbname:<db_name>, port:5432}")
  env         = var.env
  env_inst    = var.env_inst
  secret_name = format("%s", "rds_db_details") # module builds the name as `"${local.env}/${var.service}/${var.secret_name}"`
  service     = local.service                  # local.service
}
