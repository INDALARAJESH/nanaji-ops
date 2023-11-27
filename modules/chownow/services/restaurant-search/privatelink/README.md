# Restaurant Search Service PrivateLink

### General

* Description: Private connection from Hermosa to Restaurant Search Service
* Created By: David Mkrtchyan
* Module Dependencies: `privatelink`
* Module Components:
* Providers : `aws`
* Terraform Version: 0.14.6

## Usage

* Terraform:

```hcl
module "privatelink" {
  source   = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/privatelink?ref=restaurant-search-privatelink-v2.0.5"
  env      = var.env
  env_inst = var.env_inst
}
```

## Module options

* Description: Input variable options and Outputs for other modules to consume

## Inputs

| Name                                       | Description                                                    | Type     | Default                          | Required |
|--------------------------------------------|----------------------------------------------------------------|----------|----------------------------------|:--------:|
| aws\_account\_id                           | AWS Account ID                                                 | `any`    | n/a                              | yes      |
| aws\_assume\_role\_name                    | n/a                                                            | `string` | `"OrganizationAccountAccessRole"`| no       |
| env                                        | Unique environment/stage name                                  | `any`    | n/a                              | yes      |
| service                                    | Name of app/service                                            | `string` | `"restaurant-search"`            | no       |
| service\_consumer\_vpc\_name               | n/a                                                            | `string` | `"main-dev"`                     | no       |
| service\_provider\_vpc\_name               | n/a                                                            | `string` | `"nc-dev"`                       | no       |
| service\_consumer\_extra\_sg\_cidr\_blocks | Allows additional CIDR blocks to be added to the VPC endpoint  | `string` | `[]`                             | no       |
| dns_overwrite                              | Overwrites var.service for DNS name                            | `string` | `[]`                             | no       |
| provider\_vpc\_private\_subnet\_tag\_key   | Filter subnets on provider VPC by NetworkZone tag              | `string` | `["privatelink"]`                | no       |
| consumer\_vpc\_private\_subnet\_tag\_key   | Filter subnets on consumer VPC by NetworkZone tag              | `string` | `["private_base"]`               | no       |

### Lessons Learned


### References

* [AWS PrivateLink](https://chownow.atlassian.net/wiki/spaces/CE/pages/2592964930/AWS+PrivateLink)
