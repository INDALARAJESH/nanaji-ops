resource "aws_secretsmanager_secret" "secret" {
  description             = var.secret_description
  name                    = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name" = var.secret_name,
    }
  )
}

resource "aws_secretsmanager_secret_version" "secret_plaintext" {
  count = var.is_kv ? 0 : 1

  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_plaintext

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "secret_kv" {
  count = var.is_kv ? 1 : 0

  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(var.secret_kv)

  lifecycle {
    ignore_changes = [secret_string]
  }
}
