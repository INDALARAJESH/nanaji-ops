<!-- BEGIN_TF_DOCS -->
# Menu Service MySQL Database

### General

* Description: Menu Service PrivateLink
* Created By: Justin Eng, Leo Khachatorians, Ha Lam
* Module Dependencies: `privatelink`
* Module Components:
* Providers : `aws`
* Terraform Version: 0.14.6

## Usage

* Terraform:

```hcl
module "privatelink" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/menu/privatelink?ref=cn-menu-privatelink-v2.1.2"
  env      = var.env
  env_inst = var.env_inst
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                                       | Description                                                    | Type | Default                          | Required |
|--------------------------------------------|----------------------------------------------------------------|------|----------------------------------|:--------:|
| aws\_account\_id                           | AWS Account ID                                                 | `any` | n/a                              | yes |
| aws\_assume\_role\_name                    | n/a                                                            | `string` | `"OrganizationAccountAccessRole"` | no |
| env                                        | Unique environment/stage name                                  | `any` | n/a                              | yes |
| service                                    | Name of app/service                                            | `string` | `"menu"`                         | no |
| service\_consumer\_vpc\_name               | n/a                                                            | `string` | `"main-dev"`                     | no |
| service\_provider\_vpc\_name               | n/a                                                            | `string` | `"nc-dev"`                       | no |
| service\_consumer\_extra\_sg\_cidr\_blocks | Allows additional CIDR blocks to be added to the VPC endpoint  | `string` | `[]`                             | no |


### Lessons Learned


### References

---

<sub>Generated with [terraform-docs](https://terraform-docs.io/) using `ops-tf-modules/.tfdocs.d/.terraform-docs.yml`<sub>
<!-- END_TF_DOCS -->
