<!-- BEGIN_TF_DOCS -->
# Hermosa Cluster on ECS

### General

* Description: Hermosa Cluster on ECS. This module deploys an ECS cluster.
* Created By: Sebastien Plisson
* Module Dependencies: `ecs_cluster`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-cluster](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-cluster/badge.svg)

## Usage

* Terraform:

```hcl
module "cluster" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-cluster?ref=cn-hermosa-ecs-cluster-v2.0.0"
  env      = var.env
  env_inst = var.env_inst
  service  = var.service
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_execute\_command\_logging | enable logging of execute command sessions to cloudwatch and S3 | `bool` | `false` | no |
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| retention\_in\_days | days to retain log events. 0 means forever. | `number` | `90` | no |
| service | name of service | `string` | `"hermosa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | n/a |
| cluster\_name | n/a |
| kms\_key\_arn | KMS key used to encrypt communication between ECS ExecuteCommand client and container |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->