#SSM Parameter resources for lambda configuration.

resource "aws_ssm_parameter" "toast_client_id" {
  name  = "${local.ssm_prefix}/toast_client_id"
  type  = "SecureString"
  value = "changeme"

  key_id = aws_kms_alias.pos_toast.name

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "toast_client_secret" {
  name  = "${local.ssm_prefix}/toast_client_secret"
  type  = "SecureString"
  value = "changeme"

  key_id = aws_kms_alias.pos_toast.name

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "dynamodb_table" {
  name  = "${local.ssm_prefix}/dynamodb_table"
  type  = "SecureString"
  value = aws_dynamodb_table.toast.name

  depends_on = [
    aws_dynamodb_table.toast
  ]

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "dynamodb_orders_table" {
  name  = "${local.ssm_prefix}/dynamodb_orders_table"
  type  = "SecureString"
  value = aws_dynamodb_table.toast_orders.name

  depends_on = [
    aws_dynamodb_table.toast_orders
  ]

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

# TODO: get rid of this once source code is fixed to no longer need it
resource "aws_ssm_parameter" "dynamodb_url" {
  name  = "${local.ssm_prefix}/dynamodb_url"
  type  = "SecureString"
  value = "https://dynamodb.${data.aws_region.current.name}.amazonaws.com"
}

resource "aws_ssm_parameter" "partner_event_queue_name" {
  name  = "${local.ssm_prefix}/partner_event_queue_name"
  type  = "SecureString"
  value = module.partner.queue_name
}

resource "aws_ssm_parameter" "menus_event_queue_name" {
  name  = "${local.ssm_prefix}/menus_event_queue_name"
  type  = "SecureString"
  value = module.menu.queue_name
}

resource "aws_ssm_parameter" "stock_event_queue_name" {
  name  = "${local.ssm_prefix}/stock_event_queue_name"
  type  = "SecureString"
  value = module.stock.queue_name
}

resource "aws_ssm_parameter" "toast_partner_event_webhook_secret" {
  name  = "${local.ssm_prefix}/toast_partner_event_webhook_secret"
  type  = "SecureString"
  value = "changeme"

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "toast_menus_event_webhook_secret" {
  name  = "${local.ssm_prefix}/toast_menus_event_webhook_secret"
  type  = "SecureString"
  value = "changeme"

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "toast_stock_event_webhook_secret" {
  name  = "${local.ssm_prefix}/toast_stock_event_webhook_secret"
  type  = "SecureString"
  value = "changeme"

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "toast_url" {
  name  = "${local.ssm_prefix}/toast_url"
  type  = "SecureString"
  value = var.toast_url
}

resource "aws_ssm_parameter" "toast_external_id_prefix" {
  name  = "${local.ssm_prefix}/toast_external_id_prefix"
  type  = "SecureString"
  value = var.toast_external_id_prefix
}

resource "aws_ssm_parameter" "kms_key_alias" {
  name  = "${local.ssm_prefix}/kms_key_alias"
  type  = "SecureString"
  value = aws_kms_alias.pos_toast.name

  depends_on = [
    aws_kms_alias.pos_toast
  ]
}

resource "aws_ssm_parameter" "hermosa_url" {
  name  = "${local.ssm_prefix}/hermosa_url"
  type  = "SecureString"
  value = var.hermosa_url
}

resource "aws_ssm_parameter" "hermosa_api_key" {
  name  = "${local.ssm_prefix}/hermosa_api_key"
  type  = "SecureString"
  value = "changeme"

  key_id = aws_kms_alias.pos_toast.name

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "slack_menu_notification_webhook_url" {
  name  = "${local.ssm_prefix}/slack_menu_notification_webhook_url"
  type  = "SecureString"
  value = "changeme"

  key_id = aws_kms_alias.pos_toast.name

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "slack_configuration_notification_webhook_url" {
  name  = "${local.ssm_prefix}/slack_configuration_notification_webhook_url"
  type  = "SecureString"
  value = "changeme"

  key_id = aws_kms_alias.pos_toast.name

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "hermosa_admin_base_url" {
  name  = "${local.ssm_prefix}/hermosa_admin_base_url"
  type  = "SecureString"
  value = var.hermosa_admin_base_url
}

resource "aws_ssm_parameter" "enable_slack_notifications" {
  name  = "${local.ssm_prefix}/enable_slack_notifications"
  type  = "SecureString"
  value = "false"

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "aws_ssm_parameter" "sentry_dsn" {
  name  = "${local.ssm_prefix}/sentry_dsn"
  type  = "SecureString"
  value = "changeme"

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
