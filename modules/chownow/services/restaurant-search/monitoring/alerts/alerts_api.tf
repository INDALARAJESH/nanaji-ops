# RSS API | Alert on a 10% request error rate in a 5 minute window
module "api_error_rate" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/api/rss_api_error_rate.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "avg(last_5m):(sum:trace.fastapi.request.errors{service:restaurant-search-api,env:${local.env}}.as_rate() / sum:trace.fastapi.request.hits{service:restaurant-search-api,env:${local.env}}.as_rate()) * 100 >= 10"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_warning_threshold   = 3
  monitor_critical_threshold  = 10
  service                     = var.api_service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search API: Total Error Rate - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}

# RSS API | Alert when p90 latency is above 350ms in a 5 minute window
module "api_p90_latency" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/api/rss_api_p90_latency.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "percentile(last_5m):p90:trace.fastapi.request{env:${local.env},service:${var.api_service_name}} > .35"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_critical_threshold  = 0.35
  service                     = var.api_service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search API: p90 Latency - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}

# RSS Proxy | Alert when p90 latency is above 450ms in a 5 minute window
module "proxy_p90_latency" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = local.proxy_env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/api/rss_proxy_p90_latency.tpl",
    {
      env           = local.proxy_env_full,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "percentile(last_5m):p90:trace.bottle.request{env:${local.proxy_env_full},service:${var.proxy_service_name},resource_name:${var.proxy_resource_name}} > .45"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_critical_threshold  = 0.45
  service                     = var.proxy_service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search Proxy: p90 Latency - ${local.proxy_env_full}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}

# RSS API | Alert on anomalous levels of low traffic over a 15 minute window
module "api_anomalous_low_traffic" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/anomaly_monitor?ref=dd-anomaly-monitor-v1.0.2"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/api/rss_api_anomalous_low_traffic.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "sum(last_1d):anomalies(sum:trace.fastapi.request.hits{env:${local.env},service:${var.api_service_name}}.as_rate(), 'basic', 2, direction='below', interval=60, alert_window='last_30m', count_default_zero='true') >= 1"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_trigger_window      = "last_30m"
  monitor_recovery_window     = "last_15m"
  monitor_critical_threshold  = 1
  monitor_warning_threshold   = 0.5
  service                     = var.api_service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search API: Anomalously Low Traffic - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}
