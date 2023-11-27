# RSS ETL | Alert on a 90% or greater total error rate over a 1 hour window
module "etl_state_machine_failure_rate" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_state_machine_failure_rate.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "sum(last_1h):sum:aws.states.executions_failed{service:restaurant-search-etl,environment:${local.env}}.as_count() / sum:aws.states.executions_started{service:restaurant-search-etl,environment:${local.env}}.as_count() * 100 > 90"
  owner                               = "chefs_toys"
  monitor_notify_audit                = false
  monitor_require_full_window         = true
  monitor_renotify_interval           = 0
  monitor_new_group_delay             = 0
  monitor_new_host_delay              = 0
  monitor_warning_threshold           = 75
  monitor_warning_recovery_threshold  = 35
  monitor_critical_threshold          = 90
  monitor_critical_recovery_threshold = 75
  service                             = var.etl_service_name
  monitor_type                        = "query alert"
  custom_monitor_name                 = "Restaurant Search ETL: 1hr Error Rate - State Machine (${local.env})"
  name_prefix                         = ""
  monitor_timeout_h                   = 1

  notification_preset_name = "hide_query"
  evaluation_delay         = 300

}

# RSS ETL | Alert whenever the kickoff DLQ receives more than 10 messages in a 15 minute window
module "etl_kickoff_dlq_messages_received" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_dlq_message_received.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "sum(last_15m):sum:aws.sqs.number_of_messages_sent{name:restaurant-search-etl-kickoff-dlq,environment:${local.env}}.as_count() > 10"
  owner                               = "chefs_toys"
  monitor_notify_audit                = false
  monitor_require_full_window         = false
  monitor_renotify_interval           = 0
  monitor_new_group_delay             = 0
  monitor_new_host_delay              = 0
  monitor_warning_threshold           = 5
  monitor_warning_recovery_threshold  = 3
  monitor_critical_threshold          = 10
  monitor_critical_recovery_threshold = 5
  service                             = var.api_service_name
  monitor_type                        = "query alert"
  custom_monitor_name                 = "Restaurant Search ETL: Kickoff DLQ Messages Received - ${local.env}"
  name_prefix                         = ""
  monitor_timeout_h                   = 1
}

# RSS ETL | Alert on irregularly low average 'Restaurant Updated' event throughput over last 90 minutes
module "etl_low_updated_event_throughput" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/anomaly_monitor?ref=dd-anomaly-monitor-v1.0.2"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_low_updated_event_throughput.tpl",
    {
      env          = local.env,
      notify_alert = join(" ", var.alert_notify_list),
      notify_warn  = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "avg(last_12h):anomalies(sum:aws.sqs.number_of_messages_sent{environment:${local.env},servicefamily:restaurantsearchservice}.as_rate(), 'agile', 1, direction='below', interval=120, alert_window='last_90m', timezone='America/Los_Angeles', seasonality='weekly', count_default_zero='true') >= 1"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_trigger_window      = "last_90m"
  monitor_recovery_window     = "last_60m"
  monitor_critical_threshold  = 1
  monitor_warning_threshold   = 0.5
  service                     = var.api_service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search ETL: Low Restaurant Updated Event Throughput - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}