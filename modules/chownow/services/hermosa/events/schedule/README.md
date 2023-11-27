# Hermosa Scheduler

### General

* Description: Maintain the Hermosa schedule
  This module creates eventbridge schedule resources.
* Created By: Warren Nisley
* Module Dependencies:
* Module Components: `hermosa`
* Providers : `aws`
* Terraform Version: 0.14.x

![chownow-services-hermosa-events-schedule](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-events-schedule/badge.svg)

### Usage

* Terraform:

```hcl
module "hermosa_events_schedule" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/events/schedule?ref=hermosa-events-schedule-v2.0.6"
  env      = var.env
  env_inst = var.env_inst

  schedule = var.schedule
}
```



### Initialization

### Terraform

* Run the hermosa scheduler module in the `hermosa/events/schedule` folder
* Example directory structure:

```
├── global
└── us-east-1
    ├── core
    ├── db
    └── services
        └── hermosa
          └── events
            └── schedule
                ├── data_sources.tf
                ├── schedule.tf
                ├── schedule_base.tf
                ├── schedule_items.tf
                └── variables.tf
```

### Sample schedule variable:
This variable should be set in the `ops` workspaces, not in the module itself. (It will need to be updated in all workspace envs)

```
variable "schedule" {
  description = "schedule implementation"

  default = {

     # to schedule an "sqs_task":
     "testing_task" = {
         item_type           = "sqs_task"
         function            = "sqs_tasks.tester.testing_task"
         schedule_expression = "rate(2 hours)"
     }

    # to schedule a handler directly:
     "test_handler" = {
         item_type           = "handler"
         function            = "test_handler"  # routing type
         schedule_expression = "rate(5 minutes)"
     }

    # sample with cron scheduling:
      "geolocation_clear_location_cache" = {
         item_type           = "sqs_task"
         function            = "sqs_tasks.geolocation.clear_location_cache"
         schedule_expression = "cron(6 9 ? * * *)"
     }

  }
}
```



### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name                 | Description                               | Options/Defaults         |  Type  | Required? | Notes          |
| :---------------------------- | :---------------------------------------- | :----------------------- | :----: | :-------: | :------------- |
| env                           | unique environment/stage name             | dev/qa/prod/stg/uat      | string |    Yes    | N/A            |
| `env_inst`                     | iteration of environment                  | eg: 00,01,02,load        | string |    No     | N/A            |
| `schedule_item_enabled_disabled`| create items enabled or disabled          | ENABLED or DISABLED      | string |    No     | N/A            |
| schedule                      | use this to override the default schedule | see sample               | dict   |    No     | N/A            |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |


### Lessons Learned



### References

schedule expression formats: https://docs.aws.amazon.com/lambda/latest/dg/services-cloudwatchevents-expressions.html

