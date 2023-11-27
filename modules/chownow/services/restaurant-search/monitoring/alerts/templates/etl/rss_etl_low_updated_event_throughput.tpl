{{#is_warning}}
[Env: ${env}] At least 50% of observed update event throughput in the last 90 minutes is below expected rates

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] At least 50% of observed update event throughput in the last 90 minutes is above expected rates

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert}}
[Env: ${env}] 100% of observed update event throughput in the last 90 minutes is below expected rates

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] Less than 100% of observed update event throughput in the last 90 minutes is at or above expected rates

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
