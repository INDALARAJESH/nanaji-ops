{{#is_warning}}
[Env: ${env}] The ETL Kickoff DLQ has received {{value}} messages over the past 5 minutes

${notify_warn}
{{/is_warning}}

{{#is_alert}}
[Env: ${env}] The ETL Kickoff DLQ has received {{value}} messages over the past 5 minutes

${notify_alert}
{{/is_alert}}

{{#is_warning_recovery}}
[Env: ${env}] ETL Kickoff DLQ has received less than {{warn_threshold}} over the past 5 minutes.

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert_recovery}}
[Env: ${env}] ETL Kickoff DLQ has received less than {{alert_threshold}} over the past 5 minutes.

${notify_alert}
{{/is_alert_recovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
