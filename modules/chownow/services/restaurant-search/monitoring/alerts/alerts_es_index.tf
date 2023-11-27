# RSS Elasticsearch Index Migration | Alerts only on
module "es_threadpool_write_queue" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/es/rss_es_high_threadpool_queue.tpl",
    {
      env          = title(local.env),
      notify_alert = join(" ", var.alert_notify_list),
      notify_warn  = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "sum(last_5m):avg:aws.es.threadpool_write_queue{env:${local.env},service:${var.service_name}} by {nodeid}.as_count() >= 150"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_critical_threshold  = 150
  monitor_warning_threshold   = 100
  service                     = var.service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search: High Threadpool Write Queue - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}

module "es_threadpool_jvmmemory_pressure" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/es/rss_es_high_threadpool_queue.tpl",
    {
      env          = title(local.env),
      notify_alert = join(" ", var.alert_notify_list),
      notify_warn  = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "avg(last_30m):avg:aws.es.jvmmemory_pressure{service:${var.service_name},env:${local.env}} by {nodeid} >= 85"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_critical_threshold  = 85
  monitor_warning_threshold   = 75
  service                     = var.service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search: High jvmmemory pressure  - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}

module "es_cpu_utilization" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/es/rss_es_high_cpu_util.tpl",
    {
      env          = title(local.env),
      notify_alert = join(" ", var.alert_notify_list),
      notify_warn  = join(" ", var.warn_notify_list),
      dashboard_url = local.dashboard_url_api
    }
  )
  monitor_query               = "avg(last_5m):avg:aws.es.cpuutilization{service:${var.service_name},env:${local.env}} by {nodeid} >= 75"
  owner                       = "chefs_toys"
  monitor_notify_audit        = false
  monitor_require_full_window = false
  monitor_renotify_interval   = 0
  monitor_new_group_delay     = 0
  monitor_new_host_delay      = 0
  monitor_critical_threshold  = 75
  monitor_warning_threshold   = 50
  service                     = var.service_name
  monitor_type                = "query alert"
  custom_monitor_name         = "Restaurant Search: High CPU Utilization - ${local.env}"
  name_prefix                 = ""
  monitor_timeout_h           = 24
}
