<!-- BEGIN_TF_DOCS -->
# Tenable On Off Lambda Module

### General

* Description: Module to shut off Tenable instances and turn them back on before they're needed to save cost
* Created By: Eric Tew
* Providers : `aws`
* Terraform Version: 0.14.7

## Usage

* Terraform:

```hcl
module "lambdas" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/lambda/functions/python3/tenable-on-off?ref=aws-lambda-tenable-on-off-v2.0.0"

  env                = var.env
  on_cron  = "cron(0 3 ? * 4 *)"
  off_cron = "cron(0 8 ? * 4 *)"
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| off\_cron | cron expression for when to turn the Tenable instances off | `string` | `"cron(0 8 ? * 4 *)"` | no |
| on\_cron | cron expression for when to turn the Tenable instances on | `string` | `"cron(0 3 ? * 4 *)"` | no |
| service | name of app/service | `string` | `"lambda"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
