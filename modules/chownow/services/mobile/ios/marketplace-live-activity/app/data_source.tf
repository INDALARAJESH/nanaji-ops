data "aws_secretsmanager_secret" "apns_signing_key_id" {
  name = "${local.env}/${var.service}/apns_signing_key_id"
}

data "aws_secretsmanager_secret_version" "apns_signing_key_id" {
  secret_id     = data.aws_secretsmanager_secret.apns_signing_key_id.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "apns_signing_key" {
  name = "${local.env}/${var.service}/apns_signing_key"
}

data "aws_secretsmanager_secret_version" "apns_signing_key" {
  secret_id     = data.aws_secretsmanager_secret.apns_signing_key.id
  version_stage = "AWSCURRENT"
}
