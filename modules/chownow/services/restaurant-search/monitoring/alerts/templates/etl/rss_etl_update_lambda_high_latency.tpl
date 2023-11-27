{{#is_warning}}
[Env: ${env}] The 1 hour average latency for update Lambda ${function} has reached {{value}}ms

${notify_warn}
{{/is_warning}}

{{#is_warning_recovery}}
[Env: ${env}] The 1 hour average latency for update Lambda ${function} has receded to normal levels.

${notify_warn}
{{/is_warning_recovery}}

{{#is_alert}}
[Env: ${env}] The 1 hour average latency for update Lambda ${function} has exceeded {{threshold}}ms

${notify_alert}
{{/is_alert}}

{{#is_alert_receovery}}
[Env: ${env}] The 1 hour average latency for update Lambda ${function} has receded below {{threshold}}ms

${notify_alert}
{{/is_alert_receovery}}

{{^is_recovery}}
[Check the dashboard](${dashboard_url})
{{/is_recovery}}
