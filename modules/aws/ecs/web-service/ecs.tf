resource "aws_ecs_task_definition" "additional" {
  family                   = local.ecs_service_name
  requires_compatibilities = var.td_requires_capabilities
  network_mode             = var.td_network_mode
  cpu                      = var.td_cpu
  memory                   = var.td_memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.app.arn
  container_definitions    = var.td_container_definitions

  // lifecycle {
  //   ignore_changes = [container_definitions]
  // }

  dynamic "volume" {
    for_each = var.host_volumes
    content {
      name = volume.value["name"]
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.ecs_service_name
    "ServiceRole" = var.service_role }
  )
}

resource "aws_ecs_service" "service_with_tg" {
  name                   = local.ecs_service_name
  cluster                = var.ecs_cluster_id
  task_definition        = aws_ecs_task_definition.additional.arn
  launch_type            = var.ecs_service_launch_type
  platform_version       = var.ecs_service_platform_version
  desired_count          = var.ecs_service_desired_count
  enable_execute_command = var.enable_execute_command
  wait_for_steady_state  = var.wait_for_steady_state
  propagate_tags         = var.propagate_tags
  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.ecs_service_name
    "ServiceRole" = var.service_role }
  )

  network_configuration {
    security_groups = var.app_security_group_ids
    subnets         = data.aws_subnet_ids.private.ids
  }

  dynamic "load_balancer" {
    for_each = var.ecs_service_tg_arns
    content {
      target_group_arn = load_balancer.value
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
    // ignore_changes = [desired_count, task_definition]
  }

}
