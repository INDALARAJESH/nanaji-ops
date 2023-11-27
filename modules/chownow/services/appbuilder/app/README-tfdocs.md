<!-- BEGIN_TF_DOCS -->
# Appbuilder

### General

* Description: AppBuilder Terraform Module
* Created By: Allen Dantes, Eric Tew
* Module Dependencies: `vpc`, `appbuilder-base`
* Provider Dependencies: `aws`

## Usage

* Terraform:

```hcl
module "appbuilder_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appbuilder/app?ref=cn-appbuilder-app-v3.0.0"

  env         = "${var.env}"
  custom_name = "mulholland"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_name | name of bucket and user | `string` | `"appbuilder"` | no |
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| service | name of app/service | `string` | `"appbuilder"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->