<!-- BEGIN_TF_DOCS -->
# Backstage DB Module

### General

* Description: Contains all db related components in backstage
* Created By: Alex Boyd
* Module Dependencies:
* Module Components:
* Providers : `aws`
* Terraform Version: 0.14.x

![cn-services-backstage](https://github.com/ChowNow/ops-tf-modules/workflows/cn-services-backstage-db/badge.svg)

## Usage

* Terraform:

```hcl
module "db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/backstage/db?ref=backstage-db-v2.0.1"

  env                     = var.env
  service                 = var.service
  db_password_secret_name = var.db_password_secret_name
  vpc_name_prefix         = var.vpc_name_prefix
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_password\_secret\_name | AWS Secret Manager {secret-name} to store database password in /{env}/{service}/{secret-name} format | `string` | `"db_password"` | no |
| db\_username | n/a | `string` | `"postgres"` | no |
| env | the environment name | `string` | `"dev"` | no |
| service | the service name | `string` | `"backstage"` | no |
| vpc\_name\_prefix | prefix added to var.env to select which vpc the service will on | `string` | `"main"` | no |

## Outputs

| Name | Description |
|------|-------------|
| db\_identifier | n/a |

### Lessons Learned

### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->