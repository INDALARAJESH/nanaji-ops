variable "name" {
  description = "unique name"
  default     = "facebook"
}

variable "service" {
  description = "unique service name"
  default     = "integration"
}

variable "api_gateway_name" {
  description = "Name of REST API gateway"
  default     = "channels"
}

variable "cors_allow_origins" {
  description = "comma separated list of allowed CORS origins"
  default     = ""
}

variable "domain_name" {
  description = "DNS domain name"
  default     = "chownowapi.com"
}

variable "subdomain_name" {
  description = "DNS subdomain name"
  default     = "channels"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
}

variable "cloudflare_domain" {
  description = "cloudflare dns domain"
  default     = "cdn.cloudflare.net"
}

variable "tag_managed_by" {
  description = "what created resource to keep track of non-IaC modifications"
  default     = "Terraform"
}

variable "lev_dd_flush_to_log" {
  description = "Lambda environment var for `datadog-lambda` DD_FLUSH_TO_LOG setting"
  default     = "true"
}

variable "lev_dd_lambda_handler" {
  description = "Lambda environment var for `datadog-lambda` specifying entrypoint handler"
  default     = "app.lambda_handler"
}

variable "lev_dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "info"
}

variable "lev_dd_trace_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_TRACE_ENABLED setting"
  default     = "true"
}

locals {
  env                   = "${var.env}${var.env_inst}"
  datadog_env           = local.env == "ncp" ? "prod" : local.env
  app_name              = "${lower(var.name)}-${lower(var.service)}"
  domain_name           = local.env == "ncp" ? var.domain_name : "${local.env}.${var.domain_name}"
  key_id                = "alias/cn-${local.app_name}-cmk-${var.env}-${data.aws_region.current.name}"
  table_name            = "${var.name}-dynamodb-${local.env}"
  lambda_classification = "${local.app_name}_${local.env}"
  dd_api_key_arn        = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/ops_api_key"

  cors_allow_origins_lower = "https://admin.${local.env}.chownow.com,https://web.${local.env}.chownow.com:3000,https://app-marketplace.${local.env}.svpn.chownow.com,https://app-order-direct.${local.env}.svpn.chownow.com,https://admin.${local.env}.svpn.chownow.com"
  cors_allow_origins_prod  = "https://admin.chownow.com,https://dashboard.chownow.com,https://direct.chownow.com,https://eat.chownow.com,https://order.chownow.com,https://ordering.chownow.com,https://web.chownow.com"
  cors_allow_origins       = local.env == "ncp" ? local.cors_allow_origins_prod : local.cors_allow_origins_lower

  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = local.app_name
  }

  extra_tags = {
    TFModule = "modules/chownow/services/facebook-business-integration/app"
  }


  lambda_env_variables = {
    DD_FLUSH_TO_LOG            = var.lev_dd_flush_to_log
    DD_LAMBDA_HANDLER          = var.lev_dd_lambda_handler
    DD_LOG_LEVEL               = var.lev_dd_log_level
    DD_SERVERLESS_LOGS_ENABLED = "false"
    DD_TRACE_ENABLED           = var.lev_dd_trace_enabled
    DD_API_KEY_SECRET_ARN      = local.dd_api_key_arn
    DD_ENV                     = local.datadog_env
    DD_SERVICE                 = local.app_name
    ENV                        = local.env
    FBE_CORS_ALLOW_HEADERS     = "Origin, Accept, Content-Type, X-CN-App-Info"
    FBE_CORS_ALLOW_ORIGINS     = local.cors_allow_origins
    FBE_DDB_TABLE_NAME         = local.table_name
    FBE_KMS_KEY_ARN            = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:alias/cn-${local.app_name}-cmk-${local.env}-${data.aws_region.current.name}"
    FBE_SECRET_NAME            = "${local.env}/${local.app_name}/app_secret"
    FBE_SENTRY_DSN             = "${local.env}/${local.app_name}/sentry_dsn"
    FBE_VERIFY_TOKEN_NAME      = "${local.env}/${local.app_name}/verify_token"
  }


}

variable "ip_set_descriptors" {
  description = "List of IPs to allow in WAF"

  default = [
    {
      type  = "IPV4"
      value = "54.183.68.210/32" # pritunl
    },
    {
      type  = "IPV4"
      value = "54.183.225.53/32" # pritunl
    },
    {
      type  = "IPV4"
      value = "52.6.18.116/32" # New pritunl
    },
    {
      type  = "IPV4"
      value = "54.227.163.228/32" # New pritunl
    },
    {
      type  = "IPV4"
      value = "173.245.48.0/20" # cloudflare
    },
    {
      type  = "IPV4"
      value = "103.21.244.0/22" # cloudflare
    },
    {
      type  = "IPV4"
      value = "103.22.200.0/22" # cloudflare
    },
    {
      type  = "IPV4"
      value = "103.31.4.0/22" # cloudflare
    },
    {
      type  = "IPV4"
      value = "141.101.64.0/18" # cloudflare
    },
    {
      type  = "IPV4"
      value = "108.162.192.0/18" # cloudflare
    },
    {
      type  = "IPV4"
      value = "190.93.240.0/20" # cloudflare
    },
    {
      type  = "IPV4"
      value = "188.114.96.0/20" # cloudflare
    },
    {
      type  = "IPV4"
      value = "197.234.240.0/22" # cloudflare
    },
    {
      type  = "IPV4"
      value = "198.41.128.0/17" # cloudflare
    },
    {
      type  = "IPV4"
      value = "131.0.72.0/22" # cloudflare
    },
    {
      type  = "IPV4"
      value = "104.24.0.0/16" # cloudflare was 104.24.0.0/14
    },
    {
      type  = "IPV4"
      value = "104.25.0.0/16" # cloudflare was 104.24.0.0/14
    },
    {
      type  = "IPV4"
      value = "104.26.0.0/16" # cloudflare was 104.24.0.0/14
    },
    {
      type  = "IPV4"
      value = "104.27.0.0/16" # cloudflare was 104.24.0.0/14
    },
    {
      type  = "IPV4"
      value = "162.158.0.0/16" # cloudflare was 162.158.0.0/15
    },
    {
      type  = "IPV4"
      value = "162.159.0.0/16" # cloudflare was 162.158.0.0/15
    },
    {
      type  = "IPV4"
      value = "104.16.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.17.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.18.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.19.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.20.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.21.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.22.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "104.23.0.0/16" # cloudflare was 104.16.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.64.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.65.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.66.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.67.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.68.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.69.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.70.0.0/16" # cloudflare was 172.64.0.0/13
    },
    {
      type  = "IPV4"
      value = "172.71.0.0/16" # cloudflare was 172.64.0.0/13
    }
  ]
}
