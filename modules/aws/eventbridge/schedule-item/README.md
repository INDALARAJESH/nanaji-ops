# Eventbridge scheduling 

### General

* Description: Schedule a single item using AWS eventbridge.
* Created By: Warren Nisley
* Module Dependencies: N/A
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-eventbridge-schedule-item](https://github.com/ChowNow/ops-tf-modules/workflows/aws-eventbridge-schedule-item/badge.svg)

### Usage

* Terraform:

```hcl
module "schedule-item" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/eventbridge/schedule-item?ref=aws-eventbridge-schedule-item-v2.0.0"

  env      = var.env
  env_inst = var.env_inst
  service  = var.service

  schedule_item_name       = each.key
  schedule_item_expression = each.value.schedule_expression
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                          | Options                           | Type     | Required? | 
| :------------------------: | :----------------------------------: | :-------------------------------: | :------: | :-------: |
| `env`                      | unique environment/stage name        |                                   | string   |  Yes      | 
| `service `                 | service name                         |eg: hermosa-schedule               | string   |  Yes      |
| `schedule_item_name`       | name of each item                    | eg: `my_daily_item`               | string   |  Yes      | 
| `schedule_item_expression` | scheduling cron or rate expression   | eg: cron(42 * * * ? *)  or rate(10) | string |  Yes      |
| `schedule_item_enabled_disabled` | enable/disable the item        | eg: ENABLED or DISABLED           | string   |  Yes      | 
| `schedule_target_arn`      | arn used to send message to target   | default is to send to SQS         | string   |  Yes      | 


### Lessons Learned


### References
