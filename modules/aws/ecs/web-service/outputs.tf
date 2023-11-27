output "aws_ecs_task_definition" {
  value = aws_ecs_task_definition.additional.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

# Conditional output for evaluating whether the service created is one with a target group or not
output "service_name" {
  value = join(",", aws_ecs_service.service_with_tg.*.name)
}

output "service_desired_count" {
  value = join(",", aws_ecs_service.service_with_tg.*.desired_count)
}
