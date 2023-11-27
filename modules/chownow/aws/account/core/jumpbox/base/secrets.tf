# Datadog Secrets
resource "aws_secretsmanager_secret" "dd_api_key" {
  name = "${local.env}/${var.service}/dd_api_key"
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id     = aws_secretsmanager_secret.dd_api_key.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Threatstack Secrets
resource "aws_secretsmanager_secret" "threatstack_key" {
  name = "${local.env}/${var.service}/threatstack_key"
}

resource "aws_secretsmanager_secret_version" "threatstack_key" {
  secret_id     = aws_secretsmanager_secret.threatstack_key.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Teleport Secrets
resource "aws_secretsmanager_secret" "teleport_selfsigned_secret" {
  name = "${local.env}/${var.service}/teleport_selfsigned_secret"
}

resource "aws_secretsmanager_secret_version" "teleport_selfsigned_secret" {
  secret_id     = aws_secretsmanager_secret.teleport_selfsigned_secret.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Sysdig Secrets
resource "aws_secretsmanager_secret" "sysdig_access_key" {
  name = "${local.env}/${var.service}/sysdig_access_key"
}

resource "aws_secretsmanager_secret_version" "sysdig_access_key" {
  secret_id     = aws_secretsmanager_secret.sysdig_access_key.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}
