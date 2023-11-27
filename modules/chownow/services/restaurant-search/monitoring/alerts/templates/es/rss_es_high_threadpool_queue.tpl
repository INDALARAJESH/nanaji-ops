{{#is_alert}}
[Env: ${env}] - ES Threadpool Write Queue is critically high.

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] - Threadpool Write Queue has recovered.

${notify_alert}
{{/is_alert_recovery}}

{{#is_warning}}
[Env: ${env}] - ES Threadpool Write Queue is abnormally high.

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] - ES Threadpool Write Queue has recovered.

${notify_warn}
{{/is_warning_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
