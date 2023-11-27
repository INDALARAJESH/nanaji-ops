resource "aws_sfn_state_machine" "step_function" {
  name     = format("%s", var.step_function_name)
  role_arn = format("%s", aws_iam_role.step_function.arn)

  definition = var.step_function_definition

  tracing_configuration {
    enabled = var.tracing_enabled
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = var.step_function_name }
  )
}
