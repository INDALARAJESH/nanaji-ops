<!-- BEGIN_TF_DOCS -->
# Menu Service MySQL Database

### General

* Description: Menu Service RDS and Hermosa Service RDS S3 connectivity
* Created By: Eric Tew
* Module Dependencies: `s3`
* Module Components:
  * `rds_s3_bucket`
  * `menu_rds_s3_role`
  * `menu_rds_s3_policy`
* Providers : `aws`
* Terraform Version: 0.14.6

## Usage

* Terraform:

```hcl
module "rds_s3" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/db?ref=cn-menu-rds_s3-v2.0.1"
  env      = var.env
  env_inst = var.env_inst
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | Unique environment/stage name | `any` | n/a | yes |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| hermosa\_account\_id | n/a | `any` | n/a | yes |
| service | Name of app/service | `string` | `"menu"` | no |



### Lessons Learned
S3 buckets have handy ownership rules! https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls#rule-configuration-block

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->