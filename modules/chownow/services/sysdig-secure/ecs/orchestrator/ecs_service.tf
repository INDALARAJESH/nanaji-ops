resource "aws_ecs_service" "orchestrator_agent" {
  name                  = local.ecs_service_name
  cluster               = aws_ecs_cluster.sysdig_ecs_orchestrator.id
  task_definition       = aws_ecs_task_definition.orchestrator_agent.arn
  desired_count         = 1
  launch_type           = "FARGATE"
  platform_version      = "1.4.0"
  propagate_tags        = var.propagate_tags
  wait_for_steady_state = var.wait_for_steady_state

  depends_on = [aws_lb_listener.ecs_orchestrator_agent]

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_orchestrator_agent.arn
    container_name   = local.container_name
    container_port   = var.orchestrator_port
  }

  network_configuration {
    subnets          = local.subnets
    security_groups  = [aws_security_group.orchestrator_agent.id]
    assign_public_ip = var.assign_public_ip
  }

  tags = local.common_tags
}
