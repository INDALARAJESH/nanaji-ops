variable "secrets_config" {
  default = {
    snowflake = {
      name = "snowflake_credentials"
      schema = {
        "user"     = "placeholder value"
        "password" = "placeholder value"
        "account"  = "placeholder value"
      }
    }
    sendgrid = {
      name = "email_credentials"
      schema = {
        "sendgrid_api_key" = "placeholder value"
      }
    }
    box = {
      name = "box_credentials"
      schema = {
        "user"     = "placeholder value"
        "password" = "placeholder value"
      }
    }

    documentdb = {
      name = "documentdb_credentials"
      schema = {
        "username" = "placeholder value"
        "password" = "placeholder value"
        "host"     = "placeholder value"
        "port"     = "placeholder value"
      }
    }

    google_starter = {
      name = "google_starter_credentials"
      schema = {
        "rsa_private_key" = "placeholder value"
      }
    }

    singleplatform_s3_access_key = {
      name = "singleplatform_s3_credentials"
      schema = {
        "aws_access_key_id"     = "placeholder value"
        "aws_secret_access_key" = "placeholder value"
      }
    }
  }
}

resource "aws_secretsmanager_secret" "channels_data" {
  for_each = var.secrets_config
  name     = "${var.env}/channels-data/${each.value.name}"
}

resource "aws_secretsmanager_secret_version" "channels_data" {
  for_each      = aws_secretsmanager_secret.channels_data
  secret_id     = each.value.id
  secret_string = jsonencode(var.secrets_config[each.key].schema)

  lifecycle {
    ignore_changes = [secret_string]
  }
}
