# this file defines the DMS task service, which is a celery-on-redis type deal for running async business logic jobs
# the redis backend doesn't live here, it lives in `db/` back in the caller state, ops repo

locals {
  # task container environment variable mappings, which differ from web in contents and in order
  task_env = {
    REDIS_HOST                 = "${var.service}-redis.${local.env}.aws.${var.domain}"
    REDIS_PORT                 = 6379
    APP_LOG_LEVEL              = "INFO"
    DJANGO_SETTINGS_MODULE     = "config.settings.standard"
    POSTGRES_DB                = var.service
    POSTGRES_HOST              = "${var.service}-master.${local.env}.aws.${var.domain}"
    POSTGRES_USER              = var.service
    SENDGRID_DELIGHTED_ENABLED = var.containers_env_config.sendgrid_delighted_enabled
    ENV                        = var.env
    KMS_KEY_ID                 = data.aws_kms_alias.ecs_env_kms_key_id.target_key_id
    NEW_RELIC_CONFIG_FILE      = "config/newrelic_task.ini"
    NEW_RELIC_ENVIRONMENT      = local.env
    AWS_MDS_S3_BUCKET          = "cn-mds-files-${local.env}"
    # required for the DD APM agent to pick up these containers
    DD_ENV     = var.env
    DD_SERVICE = "dms"
  }

  # the task containers run persistently to perform async busines logic jobs
  task_container = {
    essential = true
    cpu       = 0
    name      = "${var.service}-task-${local.env}"
    image     = "${data.aws_ecr_repository.service.repository_url}:${var.task_container_tag}"
    logConfiguration = {
      logDriver = "awsfirelens"
      options = {
        Name       = "datadog"
        Host       = var.firelens_options_dd_host
        TLS        = "on"
        dd_service = var.service
        dd_source  = "fargate"
        dd_tags    = "env:${local.env},role:task"
        provider   = "ecs"
      }
      secretOptions = [{
        name      = "apikey"
        valueFrom = data.aws_secretsmanager_secret_version.dd_ops_api_key.secret_id
      }]
    }
    mountPoints  = []
    portMappings = []
    volumesFrom  = []
    entrypoint   = ["sh", var.container_entrypoint_task]
    command      = ["-A", "config", "worker", "-l", "info"]
    environment  = [for k, v in local.task_env : { name : tostring(k), value : tostring(v) }]
    secrets = flatten([
      for item in local.ecs_secrets : [
        for k, v in item : { name : tostring(k), valueFrom : tostring(v) }
      ]
    ])
  }
}

# permissions for the DMS "task worker" containers
data "aws_iam_policy_document" "ecs_task_policy" {
  statement {
    effect    = "Allow"
    actions   = ["kms:Encrypt", "kms:Decrypt"]
    resources = [data.aws_kms_alias.ecs_env_kms_key_id.target_key_arn]
  }
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/${var.service}/*",
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/shared-${var.service}/*",
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectAcl",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::${local.s3_bucket_name}/*",
      "arn:aws:s3:::${local.s3_bucket_name}"
    ]
  }
  statement {
    effect  = "Allow"
    actions = ["sns:Publish"]
    resources = [
      data.aws_sns_topic.order_delivery.arn
    ]
  }
}

# actually creates the task worker service, task definition, etc.
module "ecs_task_service" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/ecs/service?ref=aws-ecs-service-v2.1.2"

  app_security_group_ids   = [aws_security_group.dms.id]
  ecs_cluster_id           = aws_ecs_cluster.dms.id
  ecs_execution_iam_policy = data.aws_iam_policy_document.ecs_execution_policy.json
  ecs_task_iam_policy      = data.aws_iam_policy_document.ecs_task_policy.json
  env                      = var.env
  env_inst                 = var.env_inst
  service                  = var.service
  service_role             = "task"
  td_container_definitions = jsonencode([
    # task worker container definition, from this file
    local.task_container,

    # shared logging sidecar, with our local config (cloudwatch log group name)
    merge(local.logging_sidecar_fragment, { logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.app.name
        awslogs-region        = data.aws_region.current.name
        awslogs-stream-prefix = "task"
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
          "role:task"
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
