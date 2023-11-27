resource "datadog_monitor" "anomaly_monitor" {
  escalation_message = var.monitor_escalation_message
  message            = var.monitor_message
  name               = local.monitor_name
  type               = var.monitor_type
  query              = var.monitor_query

  notify_no_data      = var.monitor_notify_no_data
  renotify_interval   = var.monitor_renotify_interval
  require_full_window = var.monitor_require_full_window
  new_host_delay      = var.monitor_new_host_delay
  new_group_delay     = var.monitor_new_group_delay

  include_tags = var.monitor_include_tags
  notify_audit = var.monitor_notify_audit
  timeout_h    = var.monitor_timeout_h

  monitor_thresholds {
    critical          = var.monitor_critical_threshold
    critical_recovery = var.monitor_critical_recovery_threshold
    warning           = var.monitor_warning_threshold
    warning_recovery  = var.monitor_warning_recovery_threshold
  }

  monitor_threshold_windows {
    recovery_window = var.monitor_recovery_window
    trigger_window  = var.monitor_trigger_window
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
