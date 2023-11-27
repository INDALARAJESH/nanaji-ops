resource "datadog_monitor" "monitor" {

  escalation_message = var.monitor_escalation_message
  message            = var.monitor_message
  name               = local.monitor_name
  type               = var.monitor_type
  query              = var.monitor_query

  notify_no_data      = var.monitor_notify_no_data
  renotify_statuses   = var.monitor_renotify_statuses
  renotify_interval   = var.monitor_renotify_interval
  require_full_window = var.monitor_require_full_window
  evaluation_delay    = var.evaluation_delay
  new_host_delay      = var.monitor_new_host_delay
  new_group_delay     = var.monitor_new_group_delay
  no_data_timeframe   = var.monitor_no_data_timeframe

  include_tags = var.monitor_include_tags
  notify_audit = var.monitor_notify_audit
  timeout_h    = var.monitor_timeout_h

  notification_preset_name = var.notification_preset_name

  monitor_thresholds {
    critical          = var.monitor_critical_threshold
    critical_recovery = var.monitor_critical_recovery_threshold
    warning           = var.monitor_warning_threshold
    warning_recovery  = var.monitor_warning_recovery_threshold
    ok                = var.monitor_ok_threshold
  }

  tags = flatten(tolist(
    [
      format("%s:%s", "env", local.env),
      format("%s:%s", "env_inst", var.env_inst),
      format("%s:%s", "managed_by", var.tag_managed_by),
      format("%s:%s", "owner", var.owner),
      format("%s:%s", "service", var.service),
  ]))

}
