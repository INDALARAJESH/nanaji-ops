data "aws_secretsmanager_secret" "ssl_key" {
  name = "${local.env}/shared-${var.service}/ssl_key"
}

data "aws_secretsmanager_secret_version" "ssl_key" {
  secret_id     = data.aws_secretsmanager_secret.ssl_key.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "ssl_cert" {
  name = "${local.env}/shared-${var.service}/ssl_cert"
}

data "aws_secretsmanager_secret_version" "ssl_cert" {
  secret_id     = data.aws_secretsmanager_secret.ssl_cert.id
  version_stage = "AWSCURRENT"
}

data "aws_secretsmanager_secret" "configuration" {
  name = "${local.env}/shared-${var.service}/configuration"
}

data "aws_secretsmanager_secret_version" "configuration" {
  secret_id     = data.aws_secretsmanager_secret.configuration.id
  version_stage = "AWSCURRENT"
}
