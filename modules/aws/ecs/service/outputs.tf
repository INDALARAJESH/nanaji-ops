output "aws_ecs_task_definition" {
  value = aws_ecs_task_definition.additional.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

# Conditional output for evaluating whether the service created is one with a target group or not
output "service_name" {
  value = var.ecs_service_tg_arn == "" ? join(",", aws_ecs_service.additional.*.name) : join(",", aws_ecs_service.additional_with_tg.*.name)
}

output "service_desired_count" {
  value = var.ecs_service_tg_arn == "" ? join(",", aws_ecs_service.additional.*.desired_count) : join(",", aws_ecs_service.additional_with_tg.*.desired_count)
}
