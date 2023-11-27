{{#is_warning}}
[Env: ${env}] ETL State Machine Failure Rate has exceeded {{warn_threshold}}%

${notify_warn}
{{/is_warning}}

{{#is_alert}}
[Env: ${env}] ETL State Machine Failure Rate has reached {{threshold}}%

${notify_alert}
{{/is_alert}}

{{#is_warning_recovery}}
[Env: ${env}] ETL State Machine Failure Rate has receded below {{warn_threshold}}%

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert_recovery}}
[Env: ${env}] ETL State Machine Failure Rate has receded below {{threshold}}%

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
