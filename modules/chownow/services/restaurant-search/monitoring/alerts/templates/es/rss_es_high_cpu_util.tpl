{{#is_alert}}
[Env: ${env}] - ES CPU Utilization is critically high.

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] - ES CPU Utilization has recovered.

${notify_alert}
{{/is_alert_recovery}}

{{#is_warning}}
[Env: ${env}] - ES CPU Utilization is abnormally high.

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] - ES CPU Utilization has recovered.

${notify_warn}
{{/is_warning_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
