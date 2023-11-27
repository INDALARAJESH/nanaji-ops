# SNS Email Subscription

### General

* Description: A module to create a SNS email subscription
* Created By: Sebastien Plisson
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-sns-topic](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sns-email-subscription/badge.svg)

### Usage

* Terraform:

```hcl
module "email_subscription" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sns/email-subscription?ref=aws-sns-email-subscription-v2.0.1"

  sns_topic_name = "topic"
  email = "test@chownow.com"
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                       | Description                                                        | Options                     | Type     | Required? | Notes |
| :----------------------------------------------- | :----------------------------------------------------------------- | :-------------------------- | :------: | :-------: | :---- |
| sns_topic_name                      | topic name                                                         |                             | string   |  Yes      | N/A   |
| email                               | recipient email address                                            |                             | string   |  Yes      | N/A   |
| filter_policy                       | filter policy json                                                 |                             | JSON String   |  No      | N/A   |

#### Outputs

| Variable Name         | Description                                                       | Type    | Notes |
| :-------------------- | :---------------------------------------------------------------- | :-----: | :---- |



### Lessons Learned


### References
