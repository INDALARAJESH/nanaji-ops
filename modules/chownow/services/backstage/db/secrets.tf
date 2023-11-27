module "postgres_password_secret" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/secrets/insert?ref=aws-secrets-insert-v2.0.1"

  env                = var.env
  secret_description = "Generated RDS Postgres Password"
  secret_name        = "${var.env}/${var.service}/${var.db_password_secret_name}"
  secret_plaintext   = module.rds_postgres.pgmaster_password
  service            = var.service
  depends_on         = [module.rds_postgres]
}