# Restaurant Search API Docs

### General

* Description: Responsible for Generating API docs
* Created By: MJ Hardin/Isaac Pak
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-api-docs](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-api-docs/badge.svg)


### Usage

* Terraform (docs module deployment):

```hcl
module "restaurant_search_docs" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/api/docs?ref=restaurant-search-api-docs-v2.0.0"

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
| service         | name of the service                                             |                         | String  | No        | defaults to restaurant-search |


### Outputs

| Variable Name      | Description           | Type   | Notes |
| ------------------ | --------------------- | ------ | ----- |
| ecr_repository_url | URL of ECR repository | string | N/A   |

### Lessons Learned

### References
