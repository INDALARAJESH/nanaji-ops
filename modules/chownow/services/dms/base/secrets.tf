###########################
# General API Key Secrets #
###########################
locals {
  # these values get used in the following for_each to create a secret object with an enforced structure
  # the key is the secret name, and the value is a map that consists of a description key and description string value
  # you should only use this block for single k=v secrets. if you require a complex structure, use a different pattern
  secrets = {
    delighted_api_key     = { description = "Delighted API key for connectivity from DMS to service" }
    doordash_api_key      = { description = "DoorDash API key for connectivity from DMS to delivery service" }
    jolt_api_key          = { description = "Jolt API key for connectivity from DMS to delivery service" }
    sendgrid_api_key      = { description = "Sendgrid API key to allow DMS to send emails" }
    sentry_dsn            = { description = "Sentry URL for DMS" }
    secret_key            = { description = "DMS application secret key" }
    pgmaster_password     = { description = "root user credentials for DMS postgres database" }
    postgres_password     = { description = "dms user credentials for allowing application to connect to DMS postgres database" }
    redis_auth_token      = { description = "Auth token for DMS redis" }
    new_relic_license_key = { description = "NewRelic license key" }
  }
}

# these secrets don't have a SecretVersion resource, we modify them by hand in the UI
resource "aws_secretsmanager_secret" "dms_secrets" {
  for_each = local.secrets

  name                    = "${local.env}/dms/${each.key}"
  description             = each.value.description
  recovery_window_in_days = 0

  tags = {
    // avoiding a tag update call during this migration.  we probably don't need this though.
    Name = "${local.env}/dms/${each.key}"
  }
}

########
# Uber #
########
locals {
  uber_secrets_config = {
    uber_secrets = {
      name = "uber_secrets"
      schema = {
        "UBER_API_URL"         = "placeholder value"
        "UBER_CLIENT_ID"       = "placeholder value"
        "UBER_CLIENT_SECRET"   = "placeholder value"
        "UBER_API_CUSTOMER_ID" = "placeholder value"
        "UBER_WEBHOOKS_SECRET" = "placeholder value"
        "UBER_API_CUSTOMER_ID" = "placeholder value"
      }
    }
  }
}

resource "aws_secretsmanager_secret" "uber_secrets" {
  for_each = local.uber_secrets_config
  name     = "${var.env}/dms/${each.value.name}"
}

resource "aws_secretsmanager_secret_version" "uber_secrets" {
  for_each      = aws_secretsmanager_secret.uber_secrets
  secret_id     = each.value.id
  secret_string = jsonencode(local.uber_secrets_config[each.key].schema)

  lifecycle {
    ignore_changes = [secret_string]
  }
}

################
# LaunchDarkly #
################
locals {
  launchdarkly_secrets_config = {
    launchdarkly_secrets = {
      name = "launchdarkly_secrets"
      schema = {
        "LAUNCHDARKLY_SDK_KEY" = "placeholder value"
      }
    }
  }
}

resource "aws_secretsmanager_secret" "launchdarkly_secrets" {
  for_each = local.launchdarkly_secrets_config
  name     = "${var.env}/dms/${each.value.name}"
}

resource "aws_secretsmanager_secret_version" "launchdarkly_secrets" {
  for_each      = aws_secretsmanager_secret.launchdarkly_secrets
  secret_id     = each.value.id
  secret_string = jsonencode(local.launchdarkly_secrets_config[each.key].schema)

  lifecycle {
    ignore_changes = [secret_string]
  }
}

########
# Twilio #
########
locals {
  twilio_secrets_config = {
    twilio_secrets = {
      name = "twilio_secrets"
      schema = {
        "TWILIO_ACCOUNT_SID"            = "placeholder value"
        "TWILIO_AUTH_TOKEN"             = "placeholder value"
        "TWILIO_PHONE_NUMBER"           = "placeholder value"
        "TWILIO_RECEIVING_PHONE_NUMBER" = "placeholder value"
        "TWILIO_API_KEY"                = "placeholder value"
        "TWILIO_API_SECRET"             = "placeholder value"
        "TWILIO_MESSAGING_SERVICE_SID"  = "placeholder value"
      }
    }
  }
}

resource "aws_secretsmanager_secret" "twilio_secrets" {
  for_each = local.twilio_secrets_config
  name     = "${var.env}/dms/${each.value.name}"
}

resource "aws_secretsmanager_secret_version" "twilio_secrets" {
  for_each      = aws_secretsmanager_secret.twilio_secrets
  secret_id     = each.value.id
  secret_string = jsonencode(local.twilio_secrets_config[each.key].schema)

  lifecycle {
    ignore_changes = [secret_string]
  }
}
