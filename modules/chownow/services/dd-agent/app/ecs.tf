resource "aws_cloudwatch_log_group" "dd_agent" {
  name              = "/aws/ecs/${local.name}"
  retention_in_days = 7

  tags = merge(local.common_tags, { "Name" = local.name })
}

resource "aws_ecs_task_definition" "dd_agent" {
  family                   = local.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn
  container_definitions = jsonencode(
    [
      {
        name      = local.name
        image     = "public.ecr.aws/datadog/agent:7.45.1"
        essential = true
        environment = [
          {
            name  = "ECS_FARGATE"
            value = "true"
          }
        ]
        secrets = [
          {
            name      = "DD_API_KEY"
            valueFrom = local.dd_api_key_arn
          }
        ]

        mountPoints = [
          {
            ContainerPath = var.config_dir
            SourceVolume  = var.config_volume
          }
        ]
        dependsOn = [
          {
            Condition     = "COMPLETE"
            ContainerName = "config-${local.name}"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.dd_agent.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "task"
          }
        }
      },
      {
        command = [
          "-c",
          "CONFIG=$(aws secretsmanager get-secret-value --secret-id ${local.config_secret} --query SecretString --output text --region ${data.aws_region.current.name}) && echo $CONFIG | base64 -d | tee ${var.config_dir}/${var.config_name} >/dev/null"
        ]
        name        = "config-${local.name}"
        image       = "amazon/aws-cli:2.11.20"
        essential   = false
        environment = []
        entrypoint  = ["/bin/bash"]
        mountPoints = [
          {
            ContainerPath = var.config_dir
            SourceVolume  = var.config_volume
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.dd_agent.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "config"
          }
        }
      },
    ]
  )

  volume {
    name = var.config_volume
  }

  tags = merge(local.common_tags, { "Name" = local.name })
}


resource "aws_ecs_service" "dd_agent" {
  name                               = local.name
  cluster                            = data.aws_ecs_cluster.dd_agent.id
  task_definition                    = aws_ecs_task_definition.dd_agent.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = true
  launch_type                        = "FARGATE"
  propagate_tags                     = "TASK_DEFINITION"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    security_groups = concat([aws_security_group.dd_agent.id], local.internal_allow_sg)
    subnets         = toset(data.aws_subnets.private.ids)
  }

  tags = merge(local.common_tags, { "Name" = local.name })
}
