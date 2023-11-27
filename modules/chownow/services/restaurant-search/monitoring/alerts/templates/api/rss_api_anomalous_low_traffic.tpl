{{#is_alert}}
[Env: ${env}] 100% of observed RSS API traffic for the past 30 minutes has been below expected volume.

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] RSS API traffic has returned to normal levels

${notify_alert}
{{/is_alert_recovery}}

{{#is_warning}}
[Env: ${env}] 50% of observed RSS API traffic for the past 30 minutes has been below expected volume.

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] RSS API traffic has returned to normal levels

${notify_warn}
{{/is_warning_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
