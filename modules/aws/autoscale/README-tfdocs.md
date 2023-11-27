<!-- BEGIN_TF_DOCS -->
# Autoscaling

### General

* Description: A module to enable AWS Application AutoScaling
* Created By: Tim Ho
* Module Dependencies: `resource-id`
* Provider Dependencies: `aws`

![aws-autoscale](https://github.com/ChowNow/ops-tf-modules/workflows/aws-autoscale/badge.svg)

## Usage

* Terraform:

```hcl
module "autoscale_target" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id = "service/${var.cluster_name}/${var.service_name}"
}

module "autoscale_step_1" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id  = "service/${var.cluster_name}/${var.service_name}"
  scaling_policy_type = "step"

  alarm_out_dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }
}

module "autoscale_step_2" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"

  env     = "sb"
  service = var.service_name

  target_resource_id  = "service/${var.cluster_name}/${var.service_name}"
  scaling_policy_type = "step"

  alarm_out_dimensions = {
    ClusterName = var.cluster_name
    ServiceName = var.service_name
  }

  policy_step_adjustments_out = [
    {
      # Between threshold and threshold+30% scale by +20%
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 30
      scaling_adjustment          = 20
    },
    {
      # Between threshold+30% and infiniti scale by +50%
      metric_interval_lower_bound = 30
      scaling_adjustment          = 50
    },
  ]
}

module "autoscale_scheduled" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/autoscale?ref=aws-autoscale-v2.1.0"
  # wait for autoscaling in api module to be set
  depends_on          = [module.api]
  env                 = var.env
  service             = local.service
  scaling_policy_type = "scheduled"
  min_capacity        = 1
  max_capacity        = 20
  scheduled_scalings = [
    { # everyday at 15:00 PM UTC
      schedule     = "cron(30 17 * * ? *)"
      min_capacity = 5
      max_capacity = 20
    },
    { # everyday at 17:00 PM UTC
      schedule     = "cron(00 18 * * ? *)"
      min_capacity = 1
      max_capacity = 20
    }
  ]
  target_resource_id = "service/${local.cluster_name}/${local.service}-${local.env}"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alarm\_description | triggers ecs autoscaling | `string` | `"This metric monitors ecs container metrics"` | no |
| alarm\_dimensions | dimensions for the alarm\_out associated metric | `map` | `{}` | no |
| alarm\_in\_evaluation\_periods | the number of periods over which data is compared to the specified threshold | `number` | `10` | no |
| alarm\_in\_period | the period in seconds over which the specified statistic is applied for alarm\_in | `number` | `60` | no |
| alarm\_in\_statistic | the statistic to apply to alarm\_in associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum | `string` | `"Average"` | no |
| alarm\_metric\_thresholds | the thresholds for the alarm's associated metric | `map` | ```{ "CPUUtilization": 50, "MemoryUtilization": 50 }``` | no |
| alarm\_namespace | the namespace for the alarm's associated metric | `string` | `"AWS/ECS"` | no |
| alarm\_out\_evaluation\_periods | the number of alarm\_out periods over which data is compared to the specified threshold | `number` | `2` | no |
| alarm\_out\_period | the period in seconds over which the specified statistic is applied for alarm\_out | `number` | `60` | no |
| alarm\_out\_statistic | the statistic to apply to alarm\_out associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum | `string` | `"Average"` | no |
| alarm\_threshold | the value against which the specified statistic is compared | `string` | `"50"` | no |
| create\_appautoscaling\_target | create appautoscaling target resource in the module if true | `bool` | `true` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| max\_capacity | maximum number of targets to scale | `number` | `5` | no |
| min\_capacity | minimum number of targets to scale | `number` | `1` | no |
| policy\_adjustment\_type | specifies whether the adjustment is an absolute number or a percentage of the current capacity | `string` | `"PercentChangeInCapacity"` | no |
| policy\_disable\_scale\_in | boolean toggle to disable scale-in | `bool` | `false` | no |
| policy\_metric\_aggregation\_type | the aggregation type for the policy's metrics | `string` | `"Average"` | no |
| policy\_min\_adjustment\_magnitude | the minimum number to adjust your scalable dimension as a result of a scaling activity | `number` | `1` | no |
| policy\_scale\_in\_cooldown | the amount of time (in seconds) after a scaling activity completes and before the next scaling activity can start | `number` | `600` | no |
| policy\_scale\_out\_cooldown | the amount of time (in seconds) after a scaling activity completes and before the next scaling activity can start | `number` | `120` | no |
| policy\_step\_adjustments\_in | list of policy step adjustments for scaling in | `list` | ```[ { "metric_interval_lower_bound": -10, "metric_interval_upper_bound": 0, "scaling_adjustment": 0 }, { "metric_interval_lower_bound": -25, "metric_interval_upper_bound": -10, "scaling_adjustment": -10 }, { "metric_interval_upper_bound": -25, "scaling_adjustment": -25 } ]``` | no |
| policy\_step\_adjustments\_out | list of policy step adjustments for scaling out | `list` | ```[ { "metric_interval_lower_bound": 0, "metric_interval_upper_bound": 10, "scaling_adjustment": 0 }, { "metric_interval_lower_bound": 10, "metric_interval_upper_bound": 25, "scaling_adjustment": 25 }, { "metric_interval_lower_bound": 25, "scaling_adjustment": 50 } ]``` | no |
| policy\_target\_conditions | map of target tracking scaling metric and value | `list` | ```[ { "metric": "ECSServiceAverageCPUUtilization", "value": 67 }, { "metric": "ECSServiceAverageMemoryUtilization", "value": 67 } ]``` | no |
| scaling\_policy\_type | type of scaling policy (valid values are step, target-tracking, scheduled) | `string` | `"target-tracking"` | no |
| schedule | schedule for scheduled scaling action | `string` | `""` | no |
| scheduled\_max\_capacity | maximum number of targets to scale on schedule | `number` | `5` | no |
| scheduled\_min\_capacity | minimum number of targets to scale on schedule | `number` | `1` | no |
| scheduled\_scalings | list of scheduled scalings | `list(object({ schedule = string, min_capacity = number, max_capacity = number }))` | `[]` | no |
| service | unique service name for project/application | `any` | n/a | yes |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |
| target\_resource\_id | resource type and unique identifier string for the resource associated with the scaling policy | `any` | n/a | yes |
| target\_scalable\_dimension | the scalable dimension associated with the scalable target | `string` | `"ecs:service:DesiredCount"` | no |
| target\_service\_namespace | the AWS service namespace of the scalable target | `string` | `"ecs"` | no |



### TODO

* Create a dedicated CloudWatch Alarms module.
* If future non-ECS projects require aws_appautoscale:
  * Set service agnostic defaults
  * Create `aws/ecs/autoscale` module that calls `aws/autoscale`/`aws/cloudwatch/alarm` with ECS-specific variables so we can enable ECS autoscaling without having to pass in so many module arguments

### Notes

* As of the time of writing, this module currently sets _sane_ defaults only for `policy_adjustment_type: PercentChangeInCapacity`.
* Scale_In/_Out CloudWatch Alarms share `alarm_threshold` because step adjustments disallow gaps between ranges. Therefore, if gap scaling is desired, this should be configured in `policy_step_adjustments_out`/`policy_step_adjustments_in`.
* Scale_In/_Out CloudWatch Alarms share `alarm_dimensions` because it is assumed that the same target will be scaling in/out.

### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->