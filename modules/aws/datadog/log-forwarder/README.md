# Datadog Log Forwarder Stack

### General

* Description: A module to create a lambda to forward cloudwatch logs to datadog
* Created By: Joe Perez
* Module Dependencies:
  * A datadog API key in secrets manager at: `env/datadog/ops_api_key`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-datadog-log-forwarder](https://github.com/ChowNow/ops-tf-modules/workflows/aws-datadog-log-forwarder/badge.svg)

### Usage

* Terraform:

* Datadog Log Forwarder example

```hcl
module "datadog_log_forward" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/datadog/log-forwarder?ref=aws-datadog-log-forwarder-v2.1.0"

  env           = "uat"
  service       = "orderetl"

}
```

* Pushing cloudwatch logs to this lambda:

```hcl
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_subscription_filter" "datadog_log_forward" {
  name            = "datadog-log-${var.service}-${local.env}"
  log_group_name  = "some-log-group-${var.service}-${local.env}"
  destination_arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:datadog-forwarder-${var.service}-${local.env}"
  filter_pattern  = ""
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
* This tells terraform to provision a cloudformation stack :shrug:
* You must create a cloudwatch log subscription filter for the log group that you want to send to datadog and point it to the datadog log forwarder lambda
* For the ncp environment, we set the environment tag in DD_TAGS to prod
*

### References

* [Send AWS Services Logs with the Datadog Lambda function](https://docs.datadoghq.com/logs/guide/send-aws-services-logs-with-the-datadog-lambda-function/?tab=awsconsole#set-up-triggers)
* [Datadog Forwarder Terraform](https://docs.datadoghq.com/serverless/forwarder/#terraform)
