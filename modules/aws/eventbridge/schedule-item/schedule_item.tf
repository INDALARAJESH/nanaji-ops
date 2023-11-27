resource "aws_scheduler_schedule" "schedule_item" {
  name       = var.schedule_item_name
  group_name = local.schedule_group_name
  state      = var.schedule_item_enabled_disabled

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = var.schedule_item_expression

  target {
    arn      = var.schedule_target_arn
    role_arn = data.aws_iam_role.eventbridge_scheduler_role.arn
    input    = var.schedule_item_json
  }
}
