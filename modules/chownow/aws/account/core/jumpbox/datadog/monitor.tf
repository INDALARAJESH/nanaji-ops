module "jumpbox_monitor" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-monitor-v2.0.6"

  env                        = local.env
  service                    = var.service
  custom_monitor_name        = "Jumpbox Monitor"
  name_prefix                = "jumpbox-monitor"
  owner                      = "devops"
  monitor_type               = "service check"
  monitor_query              = "\"datadog.agent.up\".over(\"service:jumpbox\").by(\"host\").last(2).count_by_status()"
  monitor_message            = "Jumpbox host unreachable on {{host.name}}\n\n@slack-ops-alerts"
  monitor_include_tags       = false
  monitor_notify_no_data     = true
  monitor_critical_threshold = 1
  monitor_warning_threshold  = 1
  monitor_ok_threshold       = 1
  monitor_no_data_timeframe  = 2
  monitor_timeout_h          = 0
  monitor_new_group_delay    = 60
  monitor_renotify_statuses  = ["alert", "no data"]
  notification_preset_name   = "hide_handles"

}
