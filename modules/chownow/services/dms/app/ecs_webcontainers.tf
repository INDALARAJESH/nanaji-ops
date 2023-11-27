# web front door service for DMS. pretty self explanatory
# many of the resources in here were split out from a module, and might be moved around later

locals {
  web_container = {
    essential   = true
    name        = local.container_name
    image       = "${data.aws_ecr_repository.service.repository_url}:${var.web_container_tag}"
    cpu         = 0 # this doesn't actually get used (Service argument takes priority), but if we dont include it we get a perpetual plan diff
    mountPoints = []
    volumesFrom = []
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = "env:${local.env},role:web"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = [{
      containerPort = tonumber(var.container_port)
      hostPort      = tonumber(var.container_port)
      protocol      = "tcp"
    }]
    entrypoint  = [var.container_entrypoint_web]
    command     = ["uwsgi", "--ini", "uwsgi.ini"]
    environment = [for k, v in local.web_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.ecs_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
  }
  web_env = {
    REDIS_HOST                 = "${var.service}-redis.${local.env}.aws.${var.domain}"
    REDIS_PORT                 = 6379
    APP_LOG_LEVEL              = "INFO"
    POSTGRES_DB                = var.service
    POSTGRES_HOST              = "${var.service}-master.${local.env}.aws.${var.domain}"
    POSTGRES_USER              = var.service
    SENDGRID_DELIGHTED_ENABLED = var.containers_env_config.sendgrid_delighted_enabled
    ENV                        = var.env
    KMS_KEY_ID                 = data.aws_kms_alias.ecs_env_kms_key_id.target_key_id
    AWS_MDS_S3_BUCKET          = "cn-mds-files-${local.env}"
    # required for the DD APM agent to pick up these containers
    DD_ENV     = var.env
    DD_SERVICE = "dms"
  }
}

resource "aws_security_group" "dms" {
  name   = "dms-web-app-sg-${local.env}"
  vpc_id = data.aws_vpc.selected.id
  ingress {
    # description = "tcp 8000 inbound from this VPC"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  ingress {
    # description = "allow self pings"
    from_port = -1
    to_port   = -1
    protocol  = "icmp"
    self      = true
  }
  egress {
    # description = "allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dms-web-app-sg-${local.env}"
  }
}

resource "aws_ecs_service" "dms_web" {
  name             = "dms-web-${local.env}"
  cluster          = aws_ecs_cluster.dms.id
  task_definition  = aws_ecs_task_definition.dms_web.arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  # ballpark price: ($0.05 * desired_count) per hour
  desired_count                     = var.web_ecs_config.desired
  wait_for_steady_state             = false
  health_check_grace_period_seconds = 0

  tags = null

  lifecycle {
    ignore_changes = [desired_count]
  }

  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    security_groups = [aws_security_group.dms.id]
    subnets         = data.aws_subnet_ids.private_base.ids
  }

  # svpn-only LB: chownow access, VPC access, etc.
  load_balancer {
    target_group_arn = data.aws_lb_target_group.dms_web.arn
    container_name   = "dms-web-${local.env}"
    container_port   = var.container_port
  }

  # cloudflare LB: only traffic from cloudflare source IPs. restricted to delivery providers.
  load_balancer {
    target_group_arn = data.aws_lb_target_group.dms_cloudflare.arn
    container_name   = "dms-web-${local.env}"
    container_port   = var.container_port
  }
}

resource "aws_ecs_task_definition" "dms_web" {
  family                   = "dms-web-${local.env}"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024" # 1 full vCPU: $0.04/hr per desired_count
  memory                   = "2048" # 2 GB: $0.009/hr per desired_count
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.app.arn
  container_definitions = jsonencode([
    # the web container from this file
    local.web_container,

    # shared logging sidecar, with our local config (cloudwatch log group name)
    merge(local.logging_sidecar_fragment, { logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.app.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "web"
      }
    } }),

    # shared datadog apm agent, with our local config (application role)
    merge(local.datadog_apm_sidecar_fragment, { logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = "http-intake.logs.datadoghq.com"
        TLS        = "on"
        dd_service = "dms"
        dd_source  = "fargate"
        dd_tags = join(",", [
          # coerce "ncp" to "prod for datadog"
          "env:${local.env == "ncp" ? "prod" : local.env}",
          "aws_env:${local.env}",
          "role:web"
        ])
        provider = "ecs"
      }
      secretOptions = [
        { name : "apikey", valueFrom : data.aws_secretsmanager_secret.dd_api_key.id }
      ]
    } })
  ])

  tags = {
    Name        = "dms-web-${local.env}"
    ServiceRole = "web"
  }
}
