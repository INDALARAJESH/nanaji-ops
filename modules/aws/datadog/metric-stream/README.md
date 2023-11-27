# Datadog Metric Stream Stack

### General

* Description: A module to create a firehose metric stream to datadog
* Created By: Allen Dantes
* Module Dependencies:
  * A datadog API key in secrets manager at: `env/datadog/ops_api_key`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-datadog-metric-stream](https://github.com/ChowNow/ops-tf-modules/workflows/aws-datadog-metric-stream/badge.svg)

### Usage

* Terraform:

* Datadog Metric Stream example

```hcl
module "datadog_metric_stream" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/metric-stream?ref=aws-datadog-metric-stream-v2.0.1"

  env           = "uat"
  service       = "datadog"

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options |  Type  | Required? | Notes |
| :------------ | :---------------------------- | :------ | :----: | :-------: | :---- |
| env           | unique environment/stage name |         | string |    Yes    | N/A   |
| env_inst      | environment instance number   | 1...n   | string |    No     | N/A   |
| service       | unique service name           |         | string |    Yes    | N/A   |



#### Outputs



### Lessons Learned



### References
