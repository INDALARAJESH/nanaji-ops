# Restaurant Search Base

### General

* Description: Stack for running restaurant search service base
* Created By: MJ Hardin
* Module Dependencies: `aws_vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-api-base](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-api-base/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "restaurant_search_base" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/api/base?ref=restaurant-search-api-base-v2.0.8"

  env      = "dev"
  vpc_name = "main-dev"
}
```

## Module Options

### Inputs

| Variable Name   | Description                                                     | Options                 | Type    | Required? | Notes                         |
| --------------- | --------------------------------------------------------------- | ----------------------- | ------- | --------- | ----------------------------- |
| env             | environment/stage --                                            | dev, uat, qa, stg, prod | String  | Yes       |                               |
| env_inst        | instance of this environment                                    | 00, 01, 02, etc.        | String  | No        | defaults to ""                |
| vpc_name        | The name of the VPC that this infrastructure will be created in |                         | String  | Yes       |                               |
| service         | name of the service                                             |                         | String  | No        | defaults to restaurant-search |
| create_ecr_repo | controls whether an ecr repo is created                         |                         | Boolean | No        | defaults to false             |
| custom_domain   | hostname that the app will be accessible from                   |                         | String  | No        | defaults to ""                |


### Outputs

| Variable Name      | Description           | Type   | Notes |
| ------------------ | --------------------- | ------ | ----- |
| ecr_repository_url | URL of ECR repository | string | N/A   |

### Lessons Learned

### References
