# SNS Topic

### General

* Description: A module to create an SNS topic
* Created By: Tim Ho
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-sns-topic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sns-topic/badge.svg)

### Usage

* Terraform:

```hcl
module "publish_from_sns" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/topic?ref=aws-sns-topic-v2.0.4"

  env            = local.env
  service        = var.service
  sns_topic_name = "${var.service}-topic-${local.env}"

  sns_cross_account_access_arn = var.sns_cross_account_access_arn
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                                    | Description                                                        | Options                     | Type     | Required? | 
| :----------------------------------------------- | :----------------------------------------------------------------- | :-------------------------- | :------: | :-------: | :---- |
| `env`                                              | unique environment/stage name                                      |                             | string   |  Yes      | 
| `service `                                         | service name                                                       |          | string   |  Yes      |
| `sns_topic_name `                                  | full sns topic name                                                |                             | string   |  Yes      | 
| `fifo_topic `                                      | boolean indicating FIFO (first-in-first-out) topic                 |                             | bool     |  No       | 
| `sns_lambda_success_feedback_sample_rate`          | percentage of successful messages to receive CloudWatch Logs for   | 0-100                       | int   |  No       | 
| `enable_lambda_feedback` | boolean toggle to enable lambda success/failure feedback           | true/false                  | bool     |  No       | 
| `sns_cross_account_access_arn` | ARN of the account to enable topic access (eg: prod account arn)  | |string | No|

#### Outputs

| Variable Name         | Description                                                       | Type    | Notes |
| :-------------------- | :---------------------------------------------------------------- | :-----: | :---- |
| arn                   | topic arn                                                         | string  |       |
| name                  | topic name                                                        | string  |       |


### Lessons Learned


### References
