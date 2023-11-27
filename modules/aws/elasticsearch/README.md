# ElastiSearch

### General

* Description: A module to create an ElastiSearch instance
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-elastisearch](https://github.com/ChowNow/ops-tf-modules/workflows/aws-elasticsearch/badge.svg)



### Usage

* Terraform 
```hcl
module "es" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/elasticsearch?ref=aws-elasticsearch-v2.0.2"

  env = "stg"
}
```

### Initialization


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                      | Description                                                     | Options                         |  Type  | Required? | Notes |
| :--------------------------------- | :-------------------------------------------------------------- | :------------------------------ | :----: | :-------: | :---- |
| env                                | unique environment/stage name                                   |                                 | string |    Yes    | N/A   |
| env_inst                           | iteration of environment                                        | eg 00,01,02,etc                 | string |    No     | N/A   |
| service                            | service name                                                    |                                 | string |    Yes    | N/A   |
| instance_type                      |                                                                 | default: t2.small.elasticsearch | string |    No     | N/A   |
| instance_count                     |                                                                 | default: 2                      |  int   |    No     | N/A   |
| number                             |                                                                 | default: 0                      |  int   |    No     | N/A   |
| domain_name                        |                                                                 |                                 | string |    No     | N/A   |
| color_suffix                       |                                                                 |                                 | string |    No     | N/A   |
| es_version                         |                                                                 | default: 5.5                    | string |    No     | N/A   |
| ebs_enabled                        | use EBS for storage                                             | default: false                  |  bool  |    No     | N/A   |
| ebs_volume_size                    |                                                                 | default: 0                      |  int   |    No     | N/A   |
| ebs_volume_type                    |                                                                 | default: ""                     | string |    No     | N/A   |
| dedicated_master_enabled           |                                                                 | default: false                  |  bool  |    No     | N/A   |
| dedicated_master_type              |                                                                 | default: ""                     | string |    No     | N/A   |
| dedicated_master_count             |                                                                 | defaukt: 0                      |  int   |    No     | N/A   |
| zone_awareness_enabled             |                                                                 | default: true                   |  bool  |    No     | N/A   |
| proxy_ip                           |                                                                 | default: ""                     | string |    No     | N/A   |
| allow_explicit_index               |                                                                 | default: "false"                | string |    No     | N/A   |
| log_publishing_index_enabled       | Log publishing option for INDEX_SLOW_LOGS is enabled or not     | default: "true"                 | string |    No     | N/A   |
| log_publishing_search_enabled      | Log publishing option for SEARCH_SLOW_LOGS is enabled or not    | default: "true"                 | string |    No     | N/A   |
| log_publishing_application_enabled | Log publishing option for ES_APPLICATION_LOGS is enabled or not | default: "true"                 | string |    No     | N/A   |
| alarm_cpuutilization_cycles        | How many evaluation periods breaking thresholds before alarming | 10                              |  int   |    No     | N/A   |
| alarm_cpuutilization_threshold     | Percentage CPU Utilization above which is alarm condition       | 90                              |  int   |    No     | N/A   |
| alarm_actions                      | List of ARNs to notifiy on alarm                                |                                 |  list  |    No     | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned


### References
