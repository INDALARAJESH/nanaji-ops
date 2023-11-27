<!-- BEGIN_TF_DOCS -->
# iOS Marketplace Live Activity App Module

### General

* Description: Creates SNS Platform Application for iOS Marketplace Live Activity
* Created By: Jobin Muthalaly
* Module Dependencies: 
* Module Components:
* Providers : `aws`, `random`
* Terraform Version: ~> 1.5.0

![chownow-services-ios-marketplace-live-activity-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-ios-marketplace-live-activity-app/badge.svg)

## Usage

* Terraform:

```hcl
module "ios_marketplace_live_activity_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/mobile/ios/marketplace-live-activity/app?ref=cn-ios-marketplace-live-activity-app-v3.0.0"

  env         = var.env
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apple\_bundle\_id | Apple Bundle ID | `string` | `"com.ChowNow.Marketplace.push-type.liveactivity"` | no |
| apple\_team\_id | Apple Team ID | `string` | `"B5A97UB9Q7"` | no |
| env | Environment | `any` | n/a | yes |
| env\_inst | Environment Instance | `string` | `""` | no |
| platform\_app\_name | Service this app belongs to | `string` | `"iOSMarketplaceLiveActivity"` | no |
| sandbox | Sandbox or Production | `bool` | `true` | no |
| service | The name of the service | `string` | `"marketplace-live-activity"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->