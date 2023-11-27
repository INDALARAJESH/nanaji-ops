<!-- BEGIN_TF_DOCS -->
# Ops Base Module

### General

* Description: This module creates the base resources for ops services.
* Created By: Sebastien Plisson
* Providers : `aws`, `random`
* Terraform Version: 1.5.x

![cn-services-ops-base](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-ops-base/badge.svg)

## Usage

* Terraform:

```hcl
module "ops_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/ops/base?ref=cn-ops-base-v3.0.0&depth=1"
  env                 = "ops"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_vpc\_name | override for vpc to use for resource placement | `string` | `""` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| name\_prefix | name prefix | `string` | `"cn"` | no |
| service | unique service name | `string` | `"ops-alb"` | no |
| vpc\_name\_prefix | name prefix to use for VPC | `string` | `"main"` | no |
| wildcard\_domain\_prefix | allows for the addition of wildcard to the name because some chownow accounts have it | `string` | `""` | no |



### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->