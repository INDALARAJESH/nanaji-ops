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

      dynamic "efs_volume_configuration" {
        for_each = (lookup(volume.value, "efs_volume_configuration", []))
        content {
          file_system_id          = efs_volume_configuration.value["file_system_id"]
          root_directory          = efs_volume_configuration.value["root_directory"]
          transit_encryption      = efs_volume_configuration.value["transit_encryption"]
          transit_encryption_port = efs_volume_configuration.value["transit_encryption_port"]
        }
      }
    }
  }

  dynamic "runtime_platform" {
    for_each = var.runtime_platform
    content {
      cpu_architecture        = runtime_platform.value["cpu_architecture"]
      operating_system_family = runtime_platform.value["operating_system_family"]
    }
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.ecs_service_name
    "ServiceRole" = var.service_role }
  )
}

resource "aws_ecs_service" "additional" {
  count = var.ecs_service_tg_arn == "" ? 1 : 0

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
    subnets         = data.aws_subnets.private.ids
  }

  lifecycle {
    ignore_changes = [desired_count]
    // ignore_changes = [desired_count, task_definition]
  }
}

resource "aws_ecs_service" "additional_with_tg" {
  count = var.ecs_service_tg_arn != "" ? 1 : 0

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
    subnets         = data.aws_subnets.private.ids
  }

  load_balancer {
    target_group_arn = var.ecs_service_tg_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
    // ignore_changes = [desired_count, task_definition]
  }

}
