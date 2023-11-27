<!-- BEGIN_TF_DOCS -->
# iOS Marketplace Live Activity Base Module

### General

* Description: Creates required base resources for iOS Marketplace Live Activity
* Created By: Jobin Muthalaly
* Module Dependencies: 
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: ~> 1.5.0

![chownow-services-ios-marketplace-live-activity-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-ios-marketplace-live-activity-base/badge.svg)

## Usage

* Terraform:

```hcl
module "marketplace_live_activity_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/mobile/ios/marketplace-live-activity/base?ref=cn-ios-marketplace-live-activity-base-v3.0.0"

  env         = var.env
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Environment | `any` | n/a | yes |
| env\_inst | Environment Instance | `string` | `""` | no |
| service | The name of the service | `string` | `"marketplace-live-activity"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->