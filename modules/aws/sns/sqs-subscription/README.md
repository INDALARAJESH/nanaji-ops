# SNS SQS Subscription

### General

* Description: A module to create a SNS SQS subscription
* Created By: Warren Nisley
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-sns-sqs_subscription](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sns-sqs_subscription/badge.svg)

### Usage

* Terraform:

```hcl
module "sqs_subscription" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/sqs-subscription?ref=aws-sns-sqs-subscription-v2.3.0"

  sns_topic_arn  = "ARN of the existing sns topic"
  sqs_queue_arn = "ARN of the existing sqs queue"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                       | Description                                                        | Options                     | Type     | Required? | Notes |
| :----------------------------------------------- | :----------------------------------------------------------------- | :-------------------------- | :------: | :-------: | :---- |
| sns_topic_arn                      | existing SNS topic ARN                                                    |                             | string   |  Yes      | N/A   |
| sns_queue_arn                      | existing SQS queue ARN                                                       |                             | string   |  Yes      | N/A   |
| filter_policy                       | filter policy json for subscription                                |                             | JSON String   |  No      | N/A   |

#### Outputs

| Variable Name         | Description                                                       | Type    | Notes |
| :-------------------- | :---------------------------------------------------------------- | :-----: | :---- |



### Lessons Learned

### References
