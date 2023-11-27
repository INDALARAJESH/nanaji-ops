resource "random_string" "secret" {
  length      = var.string_length
  special     = var.string_special
  lower       = var.string_lower
  min_lower   = var.string_min_lower
  upper       = var.string_upper
  min_upper   = var.string_min_upper
  min_numeric = var.string_min_numeric
  min_special = var.string_min_special
}

resource "aws_secretsmanager_secret" "mongobackup" {
  description             = "mongodb backup credentials"
  name                    = "${local.env}/backup/mongobackup"
  recovery_window_in_days = var.recovery_window_in_days


  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "${local.env}/backup/mongobackup",
    )
  )

}

resource "aws_secretsmanager_secret_version" "mongobackup" {
  secret_id     = aws_secretsmanager_secret.mongobackup.id
  secret_string = jsonencode(map("mongobackup", random_string.secret.result))

  lifecycle {
    ignore_changes = [secret_string]
  }
}


resource "aws_secretsmanager_secret" "encryption_key" {
  description             = "gpg encryption key for encrypting backups prior to storage"
  name                    = "${local.env}/backup/encryption_key"
  recovery_window_in_days = var.recovery_window_in_days


  tags = merge(
    local.common_tags,
    var.extra_tags,
    map(
      "Name", "${local.env}/backup/encryption_key",
    )
  )

}

resource "aws_secretsmanager_secret_version" "encryption_key" {
  secret_id     = aws_secretsmanager_secret.encryption_key.id
  secret_string = random_string.secret.result

  lifecycle {
    ignore_changes = [secret_string]
  }
}
