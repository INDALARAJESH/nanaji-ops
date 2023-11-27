resource "random_string" "secret" {
  length           = var.string_length
  special          = var.string_special
  override_special = var.string_override_special
  lower            = var.string_lower
  min_lower        = var.string_min_lower
  upper            = var.string_upper
  min_upper        = var.string_min_upper
  min_numeric      = var.string_min_numeric
  min_special      = var.string_min_special
}

resource "aws_secretsmanager_secret" "secret" {
  description             = var.description
  name                    = "${local.env}/${var.service}/${var.secret_name}"
  recovery_window_in_days = var.recovery_window_in_days


  tags = merge(
    local.common_tags,
    var.extra_tags,
    tomap({
      Name = "${local.env}/${var.service}/${var.secret_name}"
    })
  )

}

resource "aws_secretsmanager_secret_version" "secret" {
  count         = var.secret_key == "" && var.enable_secret_version == 1 ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = random_string.secret.result

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_version" "secret_key_value" {
  count         = var.secret_key != "" && var.enable_secret_version == 1 ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = jsonencode(tomap({ "${var.secret_key}" = random_string.secret.result }))

  lifecycle {
    ignore_changes = [secret_string]
  }
}
