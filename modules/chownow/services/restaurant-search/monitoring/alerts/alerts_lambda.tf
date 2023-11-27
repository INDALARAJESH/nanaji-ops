# RSS ETL Lambda | Alert on 90% Fetch error rate over the last hour
module "etl_update_lambda_fetch_error_rate" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_error_rate.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-fetch-${local.env}",
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "sum(last_1h):(sum:aws.lambda.errors{functionname:restaurant-search-etl-fetch-${local.env}}.as_count() / sum:aws.lambda.invocations{functionname:restaurant-search-etl-fetch-${local.env}}.as_count()) * 100 > 90"
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
  custom_monitor_name                 = "Restaurant Search ETL: 1hr Error Rate - Fetch Lambda (${local.env})"
  name_prefix                         = ""
  monitor_timeout_h                   = 1

  notification_preset_name = "hide_query"
  evaluation_delay         = 300
}

# RSS ETL Lambda | Alert on 90% Delete error rate over the last hour
module "etl_update_lambda_delete_error_rate" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_error_rate.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-delete-${local.env}",
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "sum(last_1h):(sum:aws.lambda.errors{functionname:restaurant-search-etl-delete-${local.env}}.as_count() / sum:aws.lambda.invocations{functionname:restaurant-search-etl-delete-${local.env}}.as_count()) * 100 > 90"
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
  custom_monitor_name                 = "Restaurant Search ETL: 1hr Error Rate - Delete Lambda (${local.env})"
  name_prefix                         = ""
  monitor_timeout_h                   = 1

  notification_preset_name = "hide_query"
  evaluation_delay         = 300
}

# RSS ETL Lambda | Alert on 90% Insert error rate over the last hour
module "etl_update_lambda_insert_error_rate" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_error_rate.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-insert-${local.env}"
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "sum(last_1h):sum:aws.lambda.errors{functionname:restaurant-search-etl-insert-${local.env}}.as_count() / sum:aws.lambda.invocations{functionname:restaurant-search-etl-insert-${local.env}}.as_count() * 100 > 90"
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
  custom_monitor_name                 = "Restaurant Search ETL: 1hr Error Rate - Insert Lambda (${local.env})"
  name_prefix                         = ""
  monitor_timeout_h                   = 1

  notification_preset_name = "hide_query"
  evaluation_delay         = 300
}

# RSS ETL Lambda | Alert on > 1.5s Fetch duration over last hour
module "etl_update_lambda_fetch_latency" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_high_latency.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-fetch-${local.env}",
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "avg(last_1h):sum:aws.lambda.duration{functionname:restaurant-search-etl-fetch-${local.env}} > 30000"
  owner                               = "chefs_toys"
  monitor_notify_audit                = false
  monitor_require_full_window         = false
  monitor_renotify_interval           = 0
  monitor_new_group_delay             = 0
  monitor_new_host_delay              = 0
  monitor_warning_threshold           = 28000
  monitor_critical_threshold          = 30000
  monitor_critical_recovery_threshold = 28000
  service                             = var.etl_service_name
  monitor_type                        = "query alert"
  custom_monitor_name                 = "Restaurant Search ETL: Update Lambda Fetch High Latency - ${local.env}"
  name_prefix                         = ""
  monitor_timeout_h                   = 1
}

#RSS ETL Lambda | Alert on > 1.5s Insert duration over last hour
module "etl_update_lambda_insert_latency" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_high_latency.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-insert-${local.env}",
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "avg(last_1h):sum:aws.lambda.duration{functionname:restaurant-search-etl-insert-${local.env}} > 30000"
  owner                               = "chefs_toys"
  monitor_notify_audit                = false
  monitor_require_full_window         = false
  monitor_renotify_interval           = 0
  monitor_new_group_delay             = 0
  monitor_new_host_delay              = 0
  monitor_warning_threshold           = 28000
  monitor_critical_threshold          = 30000
  monitor_critical_recovery_threshold = 28000
  service                             = var.etl_service_name
  monitor_type                        = "query alert"
  custom_monitor_name                 = "Restaurant Search ETL: Update Lambda Insert High Latency - ${local.env}"
  name_prefix                         = ""
  monitor_timeout_h                   = 1
}

#RSS ETL Lambda | Alert on > 1.5s Delete duration over last hour
module "etl_update_lambda_delete_latency" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.5"

  env      = var.env
  env_inst = var.env_inst
  monitor_message = templatefile("${path.module}/templates/etl/rss_etl_update_lambda_high_latency.tpl",
    {
      env           = local.env,
      notify_alert  = join(" ", var.alert_notify_list),
      notify_warn   = join(" ", var.warn_notify_list),
      function      = "restaurant-search-etl-delete-${local.env}",
      dashboard_url = local.dashboard_url_etl
    }
  )
  monitor_query                       = "avg(last_1h):sum:aws.lambda.duration{functionname:restaurant-search-etl-delete-${local.env}} > 30000"
  owner                               = "chefs_toys"
  monitor_notify_audit                = false
  monitor_require_full_window         = false
  monitor_renotify_interval           = 0
  monitor_new_group_delay             = 0
  monitor_new_host_delay              = 0
  monitor_warning_threshold           = 28000
  monitor_critical_threshold          = 30000
  monitor_critical_recovery_threshold = 28000
  service                             = var.etl_service_name
  monitor_type                        = "query alert"
  custom_monitor_name                 = "Restaurant Search ETL: Update Lambda Delete High Latency - ${local.env}"
  name_prefix                         = ""
  monitor_timeout_h                   = 1
}
