# Eventbridge scheduling

### General

* Description: Create base modules used to build an eventbridge schedule
* Created By: Warren Nisley
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-eventbridge-schedule-base](https://github.com/ChowNow/ops-tf-modules/workflows/aws-eventbridge-schedule-base/badge.svg)

### Usage

* Terraform:

```hcl
module "eventbridge-schedule-item-base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/eventbridge/schedule-base?ref=aws-eventbridge-schedule-base-v2.0.2"
  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  target_sqs_queue_name  = var.target_sqs_queue_name
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name           | Description                          | Options            | Type     | Required? |
| :---------------------: | :----------------------------------: | :----------------: | :------: | :-------: |
| `env`                   | unique environment/stage name        |                    | string   |  Yes      |
| `service `              | service name                         |                    | string   |  Yes      |
| `target_sqs_queue_name` | name of the target SQS queue         | eg: hermosa-events | string   |  Yes      |

### Lessons Learned


### References
