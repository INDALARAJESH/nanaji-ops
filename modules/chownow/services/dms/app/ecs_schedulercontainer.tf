# this file contains the celery beat scheduler task definition and service, which is an always-on process
# that triggers periodic DMS jobs. it should always be running, and there should be at most one scheduler process

locals {
  # scheduler service uses the shared secrets list from ecs.tf
  scheduler_container = {
    essential = true
    name      = "dms-scheduler-${local.env}"
    image     = "${data.aws_ecr_repository.service.repository_url}:${var.task_container_tag}"
    cpu       = 0
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = "env:${local.env},role:scheduler"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    portMappings = []
    mountPoints  = []
    volumesFrom  = []
    # the scheduler is basically a task container, so it uses those vars/mappings
    entrypoint  = ["sh", var.container_entrypoint_task]
    command     = ["-A", "config", "beat", "-l", "info"]
    environment = [for k, v in local.task_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.ecs_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
  }

}


module "ecs_scheduler_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.2"

  app_security_group_ids    = [aws_security_group.dms.id]
  ecs_cluster_id            = aws_ecs_cluster.dms.id
  ecs_execution_iam_policy  = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy       = data.aws_iam_policy_document.ecs_task_policy.json
  env                       = var.env
  env_inst                  = var.env_inst
  service                   = var.service
  service_role              = "scheduler"
  ecs_service_desired_count = 1 # this should never be higher than 1
  td_container_definitions = jsonencode([
    # scheduler container definition, from this file
    local.scheduler_container,

    # logging sidecar, with our config (cloudwatch log group name)
    merge(local.logging_sidecar_fragment, { logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.app.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "scheduler"
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
          "role:scheduler"
        ])
        provider = "ecs"
      }
      secretOptions = [
        { name : "apikey", valueFrom : data.aws_secretsmanager_secret.dd_api_key.id }
      ]
    } })
  ])
  vpc_name_prefix = var.vpc_name_prefix
}
