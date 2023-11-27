resource "aws_ecs_task_definition" "task" {
  count = var.task_lifecycle_ignore_changes ? 0 : 1

  family                   = "${local.service}-${local.env}"
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
    { "Name" = "${local.service}-${local.env}"
    "ServiceRole" = var.service_role }
  )

}

resource "aws_ecs_task_definition" "task_lifecycle_ignore_changes" {
  count = var.task_lifecycle_ignore_changes ? 1 : 0

  family                   = "${local.service}-${local.env}"
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

  lifecycle {
    ignore_changes = [
      container_definitions,
    ]
  }

  tags = merge(
    local.common_tags,
    var.extra_tags,
    { "Name" = "${local.service}-${local.env}"
    "ServiceRole" = var.service_role }
  )

}
