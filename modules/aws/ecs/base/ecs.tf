###############
# ECS General #
###############
resource "aws_ecs_cluster" "app" {
  name = "${var.service}-${local.env}"

  setting {
    name  = var.ecs_cluster_setting_name
    value = var.ecs_cluster_setting_value
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${var.service}-${local.env}" }
  )
}

resource "aws_ecs_task_definition" "app" {
  family                   = local.ecs_service_name
  requires_compatibilities = var.td_requires_capabilities
  network_mode             = var.td_network_mode
  cpu                      = var.td_cpu
  memory                   = var.td_memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.app.arn
  container_definitions    = var.td_container_definitions

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

  // lifecycle {
  //   ignore_changes = [container_definitions]
  // }

}

resource "aws_ecs_service" "app" {
  name                   = local.ecs_service_name
  cluster                = aws_ecs_cluster.app.id
  task_definition        = aws_ecs_task_definition.app.arn
  launch_type            = var.ecs_service_launch_type
  platform_version       = var.ecs_service_platform_version
  desired_count          = var.ecs_service_desired_count
  wait_for_steady_state  = var.wait_for_steady_state
  enable_execute_command = var.enable_execute_command
  propagate_tags         = var.propagate_tags
  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = local.ecs_service_name
    "ServiceRole" = var.service_role }
  )

  network_configuration {
    security_groups = concat(var.additional_security_group_ids, [aws_security_group.app.id])
    subnets         = data.aws_subnets.private.ids
  }

  load_balancer {
    target_group_arn = var.ecs_service_tg_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    // create_before_destroy = true
    ignore_changes = [desired_count]
    // ignore_changes = [desired_count, task_definition]
  }


  depends_on = [aws_ecs_task_definition.app, aws_iam_policy.execution, aws_iam_policy.app]
}
