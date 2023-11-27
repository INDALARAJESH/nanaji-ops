variable "name" {
  description = "unique name"
  default     = "mpr-ir"
}

variable "service" {
  description = "unique service name"
  default     = "mparticle"
}

variable "env" {
  description = "unique environment name"
}

variable "env_inst" {
  description = "environment instance, eg 01 added to stg01"
  default     = ""
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
  env                      = "${var.env}${var.env_inst}"
  ir_app_name              = "${lower(var.name)}-${lower(var.service)}"
  ir_lambda_classification = "${local.ir_app_name}-${local.env}"
  dd_api_key_arn           = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${local.env}/datadog/ops_api_key"


  common_tags = {
    Environment         = local.env
    EnvironmentInstance = var.env_inst
    ManagedBy           = var.tag_managed_by
    Service             = local.ir_app_name
  }

  extra_tags = {
    TFModule = "modules/chownow/services/mparticle/app"
  }


  lambda_env_variables = {
    DD_FLUSH_TO_LOG            = var.lev_dd_flush_to_log
    DD_LAMBDA_HANDLER          = var.lev_dd_lambda_handler
    DD_LOG_LEVEL               = var.lev_dd_log_level
    DD_SERVERLESS_LOGS_ENABLED = "false"
    DD_TRACE_ENABLED           = var.lev_dd_trace_enabled
    DD_API_KEY_SECRET_ARN      = local.dd_api_key_arn
    DD_ENV                     = local.env
    DD_SERVICE                 = local.ir_app_name
    ENV                        = local.env
  }


}
