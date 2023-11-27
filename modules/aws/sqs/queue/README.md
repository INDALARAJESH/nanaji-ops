# SQS Queue

### General

* Description: A module to create an SQS queue.
* Created By: Warren Nisley
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-sqs-queue](https://github.com/ChowNow/ops-tf-modules/workflows/aws-sqs-queue/badge.svg)

### Usage

* Terraform:

```hcl
module "sqs_queue" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/sqs/queue?ref=aws-sqs-queue-v2.2.0"

  env            = local.env
  service        = var.service
  sqs_queue_name = local.sqs_queue_name
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                                                 | Options            | Type                | Required? | Notes         |
|--:-------------------------|--:----------------------------------------------------------|--:-----------------|--:-:----------------|--:-:------|--:------------|
| env                        | unique environment/stage name                               |                    | string              | Yes       | N/A           |
| service                    | service name                                                | hermosa, flex, etc | string              | Yes       | N/A           |
| sqs_queue_name             | full sqs queue name                                         |                    | string              | Yes       | N/A           |
| visibility_timeout_seconds | visibility timeout                                          |                    | int                 | No        | N/A           |
| message_retention_seconds  | retention seconds                                           |                    | int                 | No        | N/A           |
| max_message_size           | max message size                                            |                    | int                 | No        | N/A           |
| delay_seconds              | delay seconds                                               |                    | int                 | No        | N/A           |
| receive_wait_time_seconds  | receive wait time                                           |                    | int                 | No        | N/A           |
| fifo_queue                 | create a fifo queue?                                        |                    | boolean             | No        | default=false |
| redrive_policy             | specify a redrive policy for queue                          |                    | JSON policy for DLQ | No        |               |
| custom_queue_policy_json     | Custom queue policy JSON to be applied to the queue. If not passed, the AWS standard queue policy is applied | default is null      | JSON(string)        | No        |               |


#### Outputs

| Variable Name         | Description                                                       | Type    | Notes |
| :-------------------- | :---------------------------------------------------------------- | :-----: | :---- |
| sqs_queue_name        | name of sqs queue created                                         | string  |
| sqs_queue_url         | url of sqs queue created                                          | string  |
| sqs_queue_arn         | arn of sqs queue created                                          | string  |


### Lessons Learned


### References
