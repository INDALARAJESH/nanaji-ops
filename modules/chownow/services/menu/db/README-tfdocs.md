<!-- BEGIN_TF_DOCS -->
# Menu Service MySQL Database

### General

* Description: Menu Service relation database
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `rds-aurora`
* Module Components:
  * `aws_rds_cluster_parameter_group`
  * `aws_db_parameter_group`
  * `menu_aurora`
* Providers : `aws`, `random`
* Terraform Version: 0.14.6

## Usage

* Terraform:

```hcl
module "db" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/db?ref=cn-menu-db-v2.0.12"
  env      = var.env
  env_inst = var.env_inst
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom\_vpc\_name | option to override destination vpc | `string` | `""` | no |
| db\_instance\_class | database instance size | `string` | `"db.t2.small"` | no |
| domain | domain name information, e.g. chownow.com | `string` | `"chownow.com"` | no |
| env | unique environment/stage name | `string` | `"dev"` | no |
| env\_inst | environment instance, eg 01 added to stg01 | `string` | `""` | no |
| password\_length | password character length | `number` | `32` | no |
| service | name of app/service | `string` | `"menu"` | no |
| service\_id | unique service identifier, eg '-in' => integrations-in | `string` | `""` | no |
| vpc\_name\_prefix | prefix added to var.env to select which vpc the service will on | `string` | `"nc"` | no |



### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
