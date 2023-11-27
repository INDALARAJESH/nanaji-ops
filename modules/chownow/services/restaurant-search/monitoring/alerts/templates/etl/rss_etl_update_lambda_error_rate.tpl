{{#is_warning}}
The 1 hour error rate for the ${function} lambda has exceeded {{warn_threshold}}%.

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
The 1 hour error rate ${function} lambda has recovered.

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert}}
The 1 hour error rate for the ${function} lambda error rate has exceed {{threshold}}%.

${notify_alert}
{{/is_alert}}

{{#is_alert_recovery}}
The 1 hour error rate ${function} lambda has recovered.

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
