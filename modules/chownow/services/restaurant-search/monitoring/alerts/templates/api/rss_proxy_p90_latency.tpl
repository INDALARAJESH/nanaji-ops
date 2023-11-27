{{#is_alert}}
[Env: ${env}] The RSS proxy is experiencing a 5-minute p90 latency greater than {{threshold}}s

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] RSS proxy 5-minute p90 latency has receded below {{threshold}}s

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
