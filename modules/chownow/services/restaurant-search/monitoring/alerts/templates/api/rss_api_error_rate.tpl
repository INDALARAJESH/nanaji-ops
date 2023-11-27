{{#is_warning}}
[Env: ${env}] The RSS API request error rate has reached {{value}}%

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] The API error rate has recovered.

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert}}
[Env: ${env}] The RSS API request error rate has exceeded {{threshold}}%

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
[Env: ${env}] The API error rate has receded below {{threshold}}%

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
