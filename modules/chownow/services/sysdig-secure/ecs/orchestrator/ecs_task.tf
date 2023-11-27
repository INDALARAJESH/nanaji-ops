resource "aws_ecs_task_definition" "orchestrator_agent" {
  family                   = local.ecs_service_name
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = local.orchestrator_container_definitions

  tags = local.common_tags
}
