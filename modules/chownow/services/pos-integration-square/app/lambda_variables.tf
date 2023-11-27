variable "lambda_runtime" {
  description = "runtime associated with lambda"
  default     = "python3.9"
}

variable "lambda_xray_tracing_enabled" {
  description = "Whether to enable X-Ray tracing for Lambda"
  default     = false
}

variable "lambda_api_autoscaling_min_capacity" {
  description = "The min capacity of the scalable target (Lambda API)"
  type        = number
  default     = 1
}

variable "lambda_api_autoscaling_max_capacity" {
  description = "The max capacity of the scalable target (Lambda API)"
  type        = number
  default     = 50
}

variable "lambda_pure_functions_autoscaling_min_capacity" {
  description = "The min capacity of the scalable target (Lambda Pure Functions @ StepFunctions)"
  type        = number
  default     = 1
}

variable "lambda_pure_functions_autoscaling_max_capacity" {
  description = "The max capacity of the scalable target (Lambda Pure Functions @ StepFunctions)"
  type        = number
  default     = 10
}

variable "lev_dd_tracing_enabled" {
  description = "Whether to enable tracing for Lambdas (DD APM requirement)"
  default     = true
}

variable "lev_dd_profiling_enabled" {
  description = "Whether to enable profiling for Lambdas (DD APM requirement)"
  default     = true
}

variable "lev_dd_lambda_handler" {
  description = "Lambda environment var for `datadog-lambda` specifying entrypoint handler"
  default     = "app.lambda_handler"
}

variable "lev_dd_flush_to_log" {
  #  Set to true (recommended) to send custom metrics asynchronously
  #  (with no added latency to your Lambda function executions) through CloudWatch Logs with the help of Datadog Forwarder.
  #  Defaults to false. If set to false, you also need to set DD_API_KEY and DD_SITE.
  description = "Lambda environment var for `datadog-lambda` DD_FLUSH_TO_LOG setting"
  default     = "true"
}

variable "lev_dd_log_level" {
  description = "Lambda environment var for `datadog-lambda` DD_LOG_LEVEL setting"
  default     = "error"
}

variable "lev_dd_serverless_logs_enabled" {
  description = "Lambda environment var for `datadog-lambda` DD_SERVERLESS_LOGS_ENABLED setting (true when using Datadog Lambda Extension; false when using Datadog Forwarder via Cloudwatch logs)"
  default     = "true"
}

variable "lev_dd_enhanced_metrics" {
  # Generate enhanced Datadog Lambda integration metrics, such as, aws.lambda.enhanced.invocations and aws.lambda.enhanced.errors. Defaults to true.
  description = "Lambda environment var for `datadog-lambda` DD_ENHANCED_METRICS setting (may affect AWS bill when used with Datadog Forwarder via Cloudwatch logs; to opt-out set it to false)"
  default     = "true"
}

variable "enable_lambda_provisioned_concurrency" {
  description = "Whether to enable Application AutoScaling - operates on Provisioned concurrency"
  type        = number
  default     = 0
}

variable "enable_lambda_autoscaling" {
  description = "Whether to enable Lambda AutoScaling"
  default     = false
}

variable "lambda_pure_functions_attributes" {
  description = "lambda pure functions attributes"
  type = map(object({
    env_variables = map(string),
  }))
  default = {
    # ORDER
    "clear_order_mappings" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.clear_order_mappings"
      }
    },
    "create_pos_order_object" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.create_pos_order_object"
      }
    },
    "create_pos_payment_object" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.create_pos_payment_object"
      }
    },
    "map_cn_items_to_pos_vendor_items" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.map_cn_items_to_pos_vendor_items"
      }
    },
    "save_order_to_the_database" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.save_order_to_the_database"
      }
    },
    "send_order_to_pos_vendor" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.send_order_to_pos_vendor"
      }
    },
    "send_payment_to_pos_vendor" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.order.send_payment_to_pos_vendor"
      }
    },

    # COMMONS
    "update_order_in_database" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.commons.update_order_in_database"
      }
    },
    "send_slack_notification" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.commons.send_slack_notification"
      }
    },

    # REFUND
    "perform_partial_refund" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.refund.perform_partial_refund"
      }
    },
    "perform_full_refund" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.refund.perform_full_refund"
      }
    }
    "perform_webhook_refund" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.refund_webhook.perform_webhook_refund"
      }
    }
  }
}

variable "lambda_cron_attributes" {
  description = "lambda cron attributes"
  type = map(object({
    env_variables                  = map(string),
    cloudwatch_schedule_expression = string,
  }))
  default = {
    "refresh_access_tokens" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.cron.refresh_access_tokens"
      },
      cloudwatch_schedule_expression = "cron(0 8 * * ? *)" # run at 08:00 UTC (01:00 PT)
    },
    "remove_expired_access_tokens" = {
      env_variables = {
        DD_LAMBDA_HANDLER = "chalicelib.functions.pure_lambdas.cron.remove_expired_access_tokens"
      },
      cloudwatch_schedule_expression = "cron(0 9 * * ? *)" # run at 09:00 UTC (02:00 PT)
    },
  }
}

locals {
  lambda_classification = format("%s_%s", local.app_name, local.env)
  lambda_image_uri      = var.image_uri

  lambda_api_env_variables = {
    SFN_ORDER_STATE_MACHINE_ARN          = module.stepfunctions_order.sfn_state_machine_arn
    SFN_REFUND_STATE_MACHINE_ARN         = module.stepfunctions_refund.sfn_state_machine_arn
    SFN_REFUND_WEBHOOK_STATE_MACHINE_ARN = module.stepfunctions_refund_webhook.sfn_state_machine_arn
    DD_LAMBDA_HANDLER                    = "app.app"
  }
  lambda_cron_env_variables           = {}
  lambda_pure_functions_env_variables = {}
  lambda_common_env_variables = {
    # DATADOG
    # DD_LAMBDA_HANDLER        = var.lev_dd_lambda_handler # this one is set on the per-function basis
    DD_FLUSH_TO_LOG            = var.lev_dd_flush_to_log
    DD_LOG_LEVEL               = var.lev_dd_log_level
    DD_SERVERLESS_LOGS_ENABLED = var.lev_dd_serverless_logs_enabled
    DD_ENHANCED_METRICS        = var.lev_dd_enhanced_metrics
    DD_PROFILING_ENABLED       = var.lev_dd_profiling_enabled
    DD_TRACE_ENABLED           = var.lev_dd_tracing_enabled
    DD_MERGE_XRAY_TRACES       = var.lambda_xray_tracing_enabled
    DD_SERVICE_MAPPING         = format("postgres:%s-postgres, redis:%s-redis, aws.kms:%s-aws-kms, aws.states:%s-aws-states", var.name, var.name, var.name, var.name)
    DD_API_KEY_SECRET_ARN      = data.aws_secretsmanager_secret.dd_api_key.arn
    DD_ENV                     = local.env == "ncp" ? "prod" : local.env # tag(env:prod) to be consistent with DD filters
    DD_SERVICE                 = local.service

    LOGGER_LOG_EVENT = var.logger_log_event # can reveal sensitive info in logs / datadog
    DEBUG            = var.debug
    LOG_LEVEL        = var.log_level
    ENV              = local.env

    DB_DETAILS_ARN_SECRET_KEY                       = data.aws_secretsmanager_secret.secrets["rds_db_details"].arn
    HMAC_SIGNATURE_KEY_ARN_SECRET_KEY               = data.aws_secretsmanager_secret.secrets["hmac_signature_key"].arn
    REDIS_CACHE_PASSWORD_ARN_SECRET_KEY             = data.aws_secretsmanager_secret.secrets["redis_auth_token"].arn
    REDIS_CACHE_HOST                                = data.aws_elasticache_replication_group.redis.primary_endpoint_address
    REDIS_CACHE_SSL                                 = var.redis_cache_ssl
    KMS_ARN_AND_KEY_ID                              = data.aws_kms_key.pos_square.arn
    MOCKED_POS_VENDOR_API                           = var.mocked_pos_vendor_api
    MOCKED_API_RANDOM_RESPONSE_TIME                 = var.mocked_api_random_response_time
    POS_VENDOR_IS_SANDBOX                           = var.pos_vendor_is_sandbox
    POS_VENDOR_API_URL                              = var.pos_vendor_api_url
    POS_VENDOR_OAUTH_CLIENT_ID                      = var.pos_vendor_oauth_client_id
    POS_VENDOR_OAUTH_CLIENT_SECRET_ARN_SECRET_KEY   = data.aws_secretsmanager_secret.secrets["pos_square_oauth_client_secret"].arn
    SENTRY_URL_ARN_SECRET_KEY                       = data.aws_secretsmanager_secret.secrets["sentry_url"].arn
    SF_API_PASSWORD_ARN_SECRET_KEY                  = data.aws_secretsmanager_secret.secrets["sf_api_password"].arn
    SF_API_SECURITY_TOKEN_ARN_SECRET_KEY            = data.aws_secretsmanager_secret.secrets["sf_api_security_token"].arn
    POS_VENDOR_WEBHOOK_SIGNATURE_KEY_ARN_SECRET_KEY = data.aws_secretsmanager_secret.secrets["pos_vendor_webhook_signature_key"].arn
    SF_API_IS_SANDBOX                               = var.sf_api_is_sandbox
    SF_API_USERNAME                                 = var.sf_api_username
    HERMOSA_DASHBOARD_URL                           = local.hermosa_dashboard_url
    STEAKS_WEBHOOK_URL_ARN_SECRET_KEY               = data.aws_secretsmanager_secret.secrets["steaks_webhook_url"].arn
    POS_VENDOR_REFUND_WEBHOOK_URL                   = var.pos_vendor_refund_webhook_url
    STEAKS_WEBHOOK_ENABLED                          = var.steaks_webhook_enabled
    METRICS_IS_ENABLED                              = var.metrics_is_enabled
    METRICS_SERVICE_NAME                            = var.metrics_service_name
    SQS_SUCCESS_QUEUE_NAME                          = data.aws_sqs_queue.success_queue.name
    SQS_FAILURE_QUEUE_NAME                          = data.aws_sqs_queue.failure_queue.name
  }
}
