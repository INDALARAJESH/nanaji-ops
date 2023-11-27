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
        name        = local.name
        image       = "nginx:latest"
        essential   = true
        environment = []

        mountPoints = [
          {
            ContainerPath = "/etc/nginx"
            SourceVolume = "service-storage"
          }
        ]
        dependsOn = [
          {
            Condition = "COMPLETE"
            ContainerName = "config-${local.name}"
          }
        ]

        portMappings = [
          {
            protocol      = "tcp"
            containerPort = 80
            hostPort      = 80
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.dd_agent.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "ecs"
          }
        }
      },
      {
        command     = [
          "-c",
          "echo \"${local.nginx_config}\" | base64 -d | tee /etc/nginx/nginx.conf"
        ]
        name        = "config-${local.name}"
        image       = "bash"
        essential   = false
        environment = []

        mountPoints = [
          {
            ContainerPath = "/etc/nginx"
            SourceVolume = "service-storage"
          }
        ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = aws_cloudwatch_log_group.dd_agent.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "ecs"
          }
        }
      },
    ]
  )

  volume {
    name = "service-storage"
  }
}

resource "aws_ecs_cluster" "dd_agent" {
  name = local.name
}

resource "aws_ecs_service" "dd_agent" {
  name                               = local.name
  cluster                            = aws_ecs_cluster.dd_agent.id
  task_definition                    = aws_ecs_task_definition.dd_agent.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = true
  launch_type                        = "FARGATE"



  network_configuration {
    security_groups = [aws_security_group.dd_agent.id]
    subnets         = toset(data.aws_subnets.private.ids)
  }

}
