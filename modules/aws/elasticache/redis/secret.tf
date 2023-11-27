resource "random_password" "redis_authtoken" {
  count = local.create_redis_authtoken == 1 ? 1 : 0

  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "redis_authtoken" {
  count = local.create_redis_authtoken == 1 ? 1 : 0

  description             = "redis auth token for ${var.service} in ${local.env}"
  name                    = "${local.env}/${var.service}/${var.secret_name}"
  recovery_window_in_days = var.secret_recovery_window


  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.env}/${var.service}/${var.secret_name}" }
  )

}

resource "aws_secretsmanager_secret_version" "redis_authtoken" {
  count = local.create_redis_authtoken == 1 ? 1 : 0

  secret_id     = aws_secretsmanager_secret.redis_authtoken[0].id
  secret_string = local.redis_authtoken

  lifecycle {
    ignore_changes = [secret_string]
  }
}
