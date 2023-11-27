# this file is for the manage container task definition, which is an on-demand process that spins up from jenkins
# it's used to run migrations almost exclusively, but in theory it can run any command or job

locals {
  # manage container secrets mappings, which are a subet of web/task
  # like the shared secrets, this must be a list of object to preserve ordering
  manage_secrets = [
    { REDIS_AUTH_TOKEN = data.aws_secretsmanager_secret_version.redis_auth_token.secret_id },
    { DELIGHTED_API_KEY = data.aws_secretsmanager_secret_version.delighted_api_key.secret_id },
    { DOORDASH_API_KEY = data.aws_secretsmanager_secret_version.doordash_api_key.secret_id },
    { JOLT_API_KEY = data.aws_secretsmanager_secret_version.jolt_api_key.secret_id },
    { NEW_RELIC_LICENSE_KEY = data.aws_secretsmanager_secret_version.new_relic_license_key.secret_id },
    { POSTGRES_PASSWORD = data.aws_secretsmanager_secret_version.postgres_password.secret_id },
    { SECRET_KEY = data.aws_secretsmanager_secret_version.secret_key.secret_id },
    { UBER_CLIENT_ID = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_CLIENT_ID::" },
    { UBER_CLIENT_SECRET = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_CLIENT_SECRET::" },
    { UBER_API_CUSTOMER_ID = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_API_CUSTOMER_ID::" }
  ]

  # the manage container is only used to run migrations on-demand
  manage_container = {
    name         = "${var.service}-manage-${local.env}"
    image        = "${data.aws_ecr_repository.service.repository_url}:${var.manage_container_tag}"
    cpu          = 0
    essential    = true
    mountPoints  = []
    portMappings = []
    volumesFrom  = []
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = "env:${local.env},role:manage"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    entrypoint  = ["python3", "manage.py"]
    command     = ["migrate"]
    environment = [for k, v in local.web_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.manage_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
  }
}

# management task definition for on-demand tasks like migrations
module "ecs_td_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/task?ref=aws-ecs-task-v2.1.4"

  env          = var.env
  env_inst     = var.env_inst
  service      = var.service
  service_role = "manage"

  task_lifecycle_ignore_changes = false

  td_container_definitions = jsonencode([
    # manage container definition, from this file
    local.manage_container,

    # logging sidecar, with our local config (cloudwatch log group name)
    merge(local.logging_sidecar_fragment, { logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.app.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "manage"
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
          "role:manage"
        ])
        provider = "ecs"
      }
      secretOptions = [
        { name : "apikey", valueFrom : data.aws_secretsmanager_secret.dd_api_key.id }
      ]
    } })
  ])

  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
}
