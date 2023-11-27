resource "aws_secretsmanager_secret" "dd_api_key" {
  name = local.dd_api_key_secret_name

  tags = merge(local.common_tags, { "Name" = local.dd_api_key_secret_name })
}

resource "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id     = aws_secretsmanager_secret.dd_api_key.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}


resource "aws_secretsmanager_secret" "threatstack_key" {
  name = local.threatstack_key_secret_name

  tags = merge(local.common_tags, { "Name" = local.threatstack_key_secret_name })
}

resource "aws_secretsmanager_secret_version" "threatstack_key" {
  secret_id     = aws_secretsmanager_secret.threatstack_key.id
  secret_string = "placeholder"

  lifecycle {
    ignore_changes = [secret_string]
  }
}
