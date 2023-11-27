resource "aws_secretsmanager_secret" "sysdig_access_key" {
  description = "Sysdig Agent Access Key"
  name        = "${local.env}/${var.service}/${var.sysdig_access_key_secret_name}"

  tags = merge(
    local.common_tags,
    var.extra_tags,
    {
      "Name"            = "${local.env}/${var.service}/${var.sysdig_access_key_secret_name}",
      "FargateReadable" = "true"
    }
  )
}

resource "aws_secretsmanager_secret_version" "sysdig_access_key" {
  secret_id     = aws_secretsmanager_secret.sysdig_access_key.id
  secret_string = "Placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}
