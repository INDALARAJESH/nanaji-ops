<!-- BEGIN_TF_DOCS -->
# Hermosa Autoscaling Requests Per Target on ECS

### General

* Description: Defines autoscaling resources using requests per target.
* Created By: Sebastien Plisson
* Module Dependencies: `autoscale`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-autoscaling-request](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-autoscaling-request/badge.svg)

## Usage

* Terraform:

```hcl
module "api_autoscaling" {
  source                   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-autoscaling-cpu-mem?ref=cn-hermosa-ecs-autoscaling-request-v2.0.0"
  env                      = var.env
  env_inst                 = var.env_inst
  service_name             = "hermosa-api-${var.env}${var.env_inst}"
  cluster_name             = "hermosa-${var.env}${var.env_inst}"
  min_count                = 2
  max_count                = 50
  alb_name                 = var.alb_name
  target_group_name        = var.target_group_name
  request_count_per_target = 700
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_name | ALB name to track request count per target | `any` | n/a | yes |
| cluster\_name | ECS cluster name | `string` | `""` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| max\_count | max number of task instances to run | `number` | `20` | no |
| min\_count | min number of task instances to run | `number` | `1` | no |
| policy\_scale\_in\_cooldown | the amount of time (in seconds) to wait until the next scaling event | `number` | `300` | no |
| request\_count\_per\_target | targeted request counts per target (task instance in the target group) | `number` | `700` | no |
| service\_name | full name of ECS service including environment | `string` | `"hermosa-task-dev"` | no |
| target\_group\_name | Target group name to track request count | `any` | n/a | yes |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->