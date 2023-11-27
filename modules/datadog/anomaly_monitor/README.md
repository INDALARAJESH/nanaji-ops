# Datadog Monitor

### General

* Description: A TerraForm module to create a DataDog anomaly monitor.
* Created By: Matt Goldeck
* Module Dependencies:
  * N/A
* Provider Dependencies:
  * Datadog
* Terraform Version: `0.14.x`

![dd-monitor](https://github.com/ChowNow/ops-tf-modules/workflows/dd-monitor/badge.svg)

### Usage

* Terraform (basic example):

```hcl
module "hermosa_500" {
  source = "git::git@github.com:chownow/ops-tf-modules.git//modules/datadog/monitor?ref=dd-anomaly-monitor-v1.0.2"

  env             = local.env
  env_inst        = var.env_inst
  name_prefix     = "500s"
  owner           = "devops"
  monitor_message = "${title(local.env)} 5xx Excess! @pagerduty-devops @slack-datadog-alerts"
  monitor_query   = "logs(\"env:${local.env} service:nginx @http.status_code:>499 -host:*webadmin\\-ck*\").index(\"*\").rollup(\"count\").last(\"5m\") > 250"
  service         = var.service

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name               | Description                                    | Options                             |  Type   | Required? | Notes                                                  |
|:----------------------------|:-----------------------------------------------|:------------------------------------|:-------:| :-------: |:-------------------------------------------------------|
| custom_monitor_name         | custom/override monitor name                   |                                     | string  |    No     | N/A                                                    |
| env                         | unique environment name                        | test/staging/prod                   | string  |    Yes    | N/A                                                    |
| env_inst                    | iteration of environment                       | eg 00,01,02,etc                     | string  |    No     | N/A                                                    |
| owner                       | group who owns this monitor                    | team/squad/department               | string  |    Yes    | N/A                                                    |
| monitor_escalation_message  | escalation message for datadog monitor         | message and alerts                  | string  |    No     | N/A                                                    |
| monitor_include_tags        | enables/disables including tags                | (default: false) true/false         | boolean |    No     | N/A                                                    |
| monitor_message             | monitor message and alert groups               | message and alerts                  | string  |    Yes    | N/A                                                    |
| monitor_notify_audit        | enables/disables notification for changes      | (default: false) true/false         | boolean |    No     | N/A                                                    |
| monitor_notify_no_data      | enables/disables alerting when no data         | (default: false) true/false         | boolean |    No     | N/A                                                    |
| monitor_renotify_interval   | minutes after last notification to alert again | minute interval                     |   int   |    No     | N/A                                                    |
| monitor_require_full_window | full window required for evaluation            | (default: true) true/false          | boolean |    No     | N/A                                                    |
| monitor_new_group_delay     | Time to allow a host to boot before eval       | (default: 300)                      |   int   |    No     | N/A                                                    |
| monitor_new_host_delay      | Time to allow a host to boot before eval       | (default: 300)                      |   int   |    No     | Depracated unless new group delay needs to be set to 0 |
| monitor_query               | query pulled from datadog monitor export       | datadog query                       | string  |    Yes    | N/A                                                    |
| monitor_timeout_h           | hours after not reporting data to resolve      | (default: 60)                       |   int   |    No     | N/A                                                    |
| monitor_type                | datadog monitor type                           | (default: log alert) see references | string  |    No     | N/A                                                    |
| name_prefix                 | datadog monitor name prefix                    |                                     | string  |    Yes    | N/A                                                    |
| service                     | unique service name                            | hermosa, dms, etc                   | string  |    Yes    | N/A                                                    |


#### Outputs

| Variable Name | Description            |  Type  | Notes |
| :------------ | :--------------------- | :----: | :---- |
|               |                        |        |       |

### Lessons Learned

* Create the query first in the interface, then instead of applying, hit the `export` button and copy that version of the query to terraform
* Datadog expects a list for the tags and separated by a `:`


### References

* [Terraform Documentation - Datadog Monitor](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor)
* [How to create a monitor](https://docs.datadoghq.com/api/latest/monitors/#create-a-monitor)
