# resources that relate to the entirety of AWS ECS, or at least, as it relates to providing DMS to ChowNow

# the cluster is shared between all DMS ECS resources
resource "aws_ecs_cluster" "dms" {
  name = "dms-${local.env}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "dms-${local.env}"
  }
}

locals {
  # secrets that should be used by every service, currently not used by `-manage` for migration ease
  # list of object to preserve ordering, otherwise terraform wants to redeploy to adjust it
  ecs_secrets = [
    { REDIS_AUTH_TOKEN = data.aws_secretsmanager_secret_version.redis_auth_token.secret_id },
    { DELIGHTED_API_KEY = data.aws_secretsmanager_secret_version.delighted_api_key.secret_id },
    { DOORDASH_API_KEY = data.aws_secretsmanager_secret_version.doordash_api_key.secret_id },
    { JOLT_API_KEY = data.aws_secretsmanager_secret_version.jolt_api_key.secret_id },
    { NEW_RELIC_LICENSE_KEY = data.aws_secretsmanager_secret_version.new_relic_license_key.secret_id },
    { POSTGRES_PASSWORD = data.aws_secretsmanager_secret_version.postgres_password.secret_id },
    { SECRET_KEY = data.aws_secretsmanager_secret_version.secret_key.secret_id },
    { SENDGRID_API_KEY = data.aws_secretsmanager_secret_version.sendgrid_api_key.secret_id },
    { SENTRY_DSN = data.aws_secretsmanager_secret_version.sentry_dsn.secret_id },
    { UBER_API_URL = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_API_URL::" },
    { UBER_CLIENT_ID = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_CLIENT_ID::" },
    { UBER_CLIENT_SECRET = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_CLIENT_SECRET::" },
    { LD_SDK_KEY = "${data.aws_secretsmanager_secret_version.launchdarkly_secrets.secret_id}:LAUNCHDARKLY_SDK_KEY::" },
    { UBER_WEBHOOKS_SECRET = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_WEBHOOKS_SECRET::" },
    { UBER_API_CUSTOMER_ID = "${data.aws_secretsmanager_secret_version.uber_secrets.secret_id}:UBER_API_CUSTOMER_ID::" },
    { TWILIO_ACCOUNT_SID = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_ACCOUNT_SID::" },
    { TWILIO_AUTH_TOKEN = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_AUTH_TOKEN::" },
    { TWILIO_PHONE_NUMBER = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_PHONE_NUMBER::" },
    { TWILIO_RECEIVING_PHONE_NUMBER = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_RECEIVING_PHONE_NUMBER::" },
    { TWILIO_API_KEY = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_API_KEY::" },
    { TWILIO_API_SECRET = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_API_SECRET::" },
    { TWILIO_MESSAGING_SERVICE_SID = "${data.aws_secretsmanager_secret_version.twilio_secrets.secret_id}:TWILIO_MESSAGING_SERVICE_SID::" }
  ]

  datadog_apm_sidecar_fragment = {
    essential   = true
    name        = "datadog-agent"
    image       = "public.ecr.aws/datadog/agent:latest"
    cpu         = 256
    memory      = 256
    mountPoints = []
    volumesFrom = []
    portMappings = [
      #https://docs.datadoghq.com/containers/amazon_ecs/apm/?tabs=ec2metadataendpoint
      { hostPort = 8126, protocol = "tcp", containerPort = 8126 }
    ]
    secrets = [for name, valueFrom in {
      DD_API_KEY = data.aws_secretsmanager_secret.dd_api_key.id
      } : { name : name, valueFrom : valueFrom }
    ]
    environment = [for name, value in {
      ECS_FARGATE              = "true"
      DD_APM_ENABLED           = "true"
      DD_APM_NON_LOCAL_TRAFFIC = "true"
      } : { name : name, value : value }
    ]
  }

  # the logging sidecar is shared and gets used by many task definitions
  # since a nested tag varies, merge it with a consumer-local structure to complete
  logging_sidecar_fragment = {
    essential         = true
    name              = var.firelens_container_name
    image             = data.aws_ssm_parameter.fluentbit.value
    cpu               = 0
    environment       = []
    memoryReservation = 50
    mountPoints       = []
    portMappings      = []
    user              = "0"
    volumesFrom       = []
    firelensConfiguration = {
      type = "fluentbit"
      options = {
        enable-ecs-log-metadata = "true"
        config-file-type        = "file"
        config-file-value       = "/fluent-bit/configs/minimize-log-loss.conf"
      }
    }
  }
}
