resource "aws_cloudwatch_log_group" "worker" {
  retention_in_days = 7
  name              = "/aws/ecs/${local.name}"
}


resource "aws_security_group" "worker" {
  name        = local.name
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_ecs_task_definition" "worker" {
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
            awslogs-group         = aws_cloudwatch_log_group.worker.name
            awslogs-region        = data.aws_region.current.name
            awslogs-stream-prefix = "ecs"
          }
        }
      }
    ]
  )
}

resource "aws_ecs_cluster" "worker" {
  name = local.name
}

resource "aws_ecs_service" "worker" {
  name                               = local.name
  cluster                            = aws_ecs_cluster.worker.id
  task_definition                    = aws_ecs_task_definition.worker.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = true
  launch_type                        = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.worker.id]
    subnets         = toset(data.aws_subnets.private.ids)
  }

}
