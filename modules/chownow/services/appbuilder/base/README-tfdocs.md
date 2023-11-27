<!-- BEGIN_TF_DOCS -->
# Appbuilder

### General

* Description: AppBuilder Terraform Module
* Created By: Allen Dantes, Eric Tew
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`

## Usage

* Terraform:

```hcl
module "appbuilder_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/appbuilder/base?ref=cn-appbuilder-base-v3.0.0"

  env = "${var.env}"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | unique environment/stage name a | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| extra\_tags | optional addition for tags | `map` | `{}` | no |
| service | name of app/service | `string` | `"appbuilder"` | no |
| tag\_managed\_by | what created resource to keep track of non-IaC modifications | `string` | `"Terraform"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->