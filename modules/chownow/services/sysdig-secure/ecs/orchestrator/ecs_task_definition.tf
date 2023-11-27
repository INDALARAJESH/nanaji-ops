locals {
  ### CONTAINER DEFINITIONS ###
  orchestrator_container = [
    {
      name  = local.container_name
      image = var.agent_image
      cpu   = 0 # Not actually used (Service takes priority), but if we don't include it we get a perpetual plan diff

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = local.log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      portMappings = [
        {
          hostPort      = var.orchestrator_port
          protocol      = "tcp"
          containerPort = var.orchestrator_port
        }
      ]
      environment = [for k, v in local.orchestrator_container_env : {
        name : tostring(k),
        value : tostring(v)
      }]
      secrets = flatten([
        for item in local.orchestrator_container_secrets : [
          for k, v in item : {
            name : tostring(k),
            valueFrom : tostring(v)
          }
        ]
      ])
    }
  ]


  ### CONTAINER ENV VARIABLES ###
  orchestrator_container_env = merge(
    local.default_container_env,
    local.upload_certificate_collector_env,
    local.configure_connection_collector_env,
    local.upload_ca_certificate_http_proxy_env,
    local.configure_connection_http_proxy_env
  )

  default_container_env = {
    CHECK_CERTIFICATE = var.check_collector_certificate
    COLLECTOR         = var.collector_host
    COLLECTOR_PORT    = var.collector_port
    TAGS              = var.agent_tags
    HOSTNAME          = local.container_hostname
    ADDITIONAL_CONF   = format("agentino_port: %s", tostring(var.orchestrator_port))
  }

  upload_certificate_collector_env = local.do_upload_ca_certificate_collector ? {
    COLLECTOR_CA_CERTIFICATE_TYPE  = var.collector_ca_certificate.type
    COLLECTOR_CA_CERTIFICATE_VALUE = var.collector_ca_certificate.value
    COLLECTOR_CA_CERTIFICATE_PATH  = var.collector_ca_certificate.path
  } : {}

  configure_connection_collector_env = local.do_configure_connection_collector ? {
    COLLECTOR_CA_CERTIFICATE = var.collector_configuration.ca_certificate
  } : {}

  upload_ca_certificate_http_proxy_env = local.do_upload_ca_certificate_http_proxy ? {
    HTTP_PROXY_CA_CERTIFICATE_TYPE  = var.http_proxy_ca_certificate.type
    HTTP_PROXY_CA_CERTIFICATE_VALUE = var.http_proxy_ca_certificate.value
    HTTP_PROXY_CA_CERTIFICATE_PATH  = var.http_proxy_ca_certificate.path
  } : {}

  configure_connection_http_proxy_env = local.do_configure_connection_http_proxy ? {
    PROXY_HOST                   = var.http_proxy_configuration.proxy_host
    PROXY_PORT                   = var.http_proxy_configuration.proxy_port
    PROXY_USER                   = var.http_proxy_configuration.proxy_user
    PROXY_SSL                    = var.http_proxy_configuration.ssl
    PROXY_SSL_VERIFY_CERTIFICATE = var.http_proxy_configuration.ssl_verify_certificate
    PROXY_CA_CERTIFICATE         = var.http_proxy_configuration.ca_certificate
  } : {}


  ### CONTAINER SECRETS ###
  orchestrator_container_secrets = [
    merge(
      local.access_key_container_secret,
      local.proxy_password_container_secret
    )
  ]

  access_key_container_secret = {
    ACCESS_KEY = local.sysdig_access_key_secret_arn
  }

  proxy_password_container_secret = local.do_configure_connection_http_proxy ? {
    PROXY_PASSWORD = var.http_proxy_configuration.proxy_password
  } : {}


  ### JSON ENCODED CONTAINER DEFINITIONS ###
  orchestrator_container_definitions = jsonencode(local.orchestrator_container)
}
