<!-- BEGIN_TF_DOCS -->
# Hermosa Autoscaling CPU & Memory Utilization Targets on ECS

### General

* Description: Defines autoscaling resources using utilization target for CPU and Memory.
* Created By: Sebastien Plisson
* Module Dependencies: `autoscale`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-autoscaling-cpu-mem](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-autoscaling-cpu-mem/badge.svg)

## Usage

* Terraform:

```hcl
module "task_autoscaling" {
  source       = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-autoscaling-cpu-mem?ref=cn-hermosa-ecs-autoscaling-cpu-mem-v2.0.0"
  env          = var.env
  env_inst     = var.env_inst
  service_name = "hermosa-task-${var.env}${var.env_inst}"
  cluster_name = "hermosa-${var.env}${var.env_inst}"
  min_count    = 2
  max_count    = 50
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| average\_cpu\_utilization | average cpu utilization target | `string` | `"70"` | no |
| average\_memory\_utilization | average cpu utilization target | `string` | `"70"` | no |
| cluster\_name | ECS cluster name | `string` | `""` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| max\_count | max number of task instances to run | `number` | `20` | no |
| min\_count | min number of task instances to run | `number` | `1` | no |
| policy\_scale\_in\_cooldown | the amount of time to wait until the next scaling event | `number` | `300` | no |
| service\_name | full name of ECS service including environment | `string` | `"hermosa-task-dev"` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->