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
