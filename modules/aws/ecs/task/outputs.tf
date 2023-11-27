output "cloudwatch_log_group_name" {
  value = var.cwlog_group_name == "" ? "" : join("", aws_cloudwatch_log_group.task.*.name)
}

output "ecs_task_definition_arn" {
  value = var.task_lifecycle_ignore_changes ? aws_ecs_task_definition.task_lifecycle_ignore_changes[0].arn : aws_ecs_task_definition.task[0].arn
}

output "ecs_task_definition_id" {
  value = var.task_lifecycle_ignore_changes ? aws_ecs_task_definition.task_lifecycle_ignore_changes[0].id : aws_ecs_task_definition.task[0].id
}
