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
