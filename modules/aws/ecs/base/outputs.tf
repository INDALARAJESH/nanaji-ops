output "aws_ecs_task_definition" {
  value = aws_ecs_task_definition.app.arn
}

output "aws_ecs_cluster" {
  value = aws_ecs_cluster.app.arn
}

output "aws_ecs_security_group_id" {
  value = aws_security_group.app.id
}

output "app_iam_role_arn" {
  value = aws_iam_role.app.arn
}

output "app_iam_role_id" {
  value = aws_iam_role.app.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.app.name
}

output "cluster_id" {
  value = aws_ecs_cluster.app.id
}

output "cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "service_name" {
  value = aws_ecs_service.app.name
}

output "service_desired_count" {
  value = aws_ecs_service.app.desired_count
}
