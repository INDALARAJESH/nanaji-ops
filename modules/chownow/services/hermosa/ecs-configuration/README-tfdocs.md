<!-- BEGIN_TF_DOCS -->
# Hermosa Configuration on ECS

### General

* Description: Hermosa Configuration and SSL files on ECS
* Created By: Sebastien Plisson
* Module Dependencies: `alb-public`, `alb_ecs_tg`, `alb_ecs_listener_rule` `alb_origin_r53`, `ecs_base`,`autoscale`,`ecs_service`
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![cn-services-hermosa-ecs-configuration](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-hermosa-ecs-configuration/badge.svg)

## Usage

* Terraform:

```hcl
module "secrets" {
  source  = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/hermosa/ecs-configuration?ref=cn-hermosa-ecs-configuration-v2.1.0"
  env     = var.env
  service = var.service
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| service | name of service | `string` | `"hermosa"` | no |

## Outputs

| Name | Description |
|------|-------------|
| configuration\_secret\_arn | n/a |
| ssl\_cert\_secret\_arn | n/a |
| ssl\_key\_secret\_arn | n/a |

### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->