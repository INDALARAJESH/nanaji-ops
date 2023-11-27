# Restaurant Search Service

### General

* Description: Stack for running restaurant search service
* Created By: MJ Hardin
* Module Dependencies: `aws_vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-api-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-api-app/badge.svg)


### Usage

* Terraform (app module deployment):

```hcl
module "restaurant_search_app" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/api/app?ref=restaurant-search-api-app-v2.0.14"

  env                     = "dev"
  api_source_code_version = "135a70b2762aee10957eb2d3c86eb31a8329a378"
  vpc_name                = "main-dev"  # should be the name of the aws_vpc created as this module's dependency
  docker_image_uri        = "229179723177.dkr.ecr.us-east-1.amazonaws.com/restaurant-search-api"
}
```

## Module Options

### Inputs

| Variable Name                    | Description                                                                   | Options                 | Type          | Required? | Notes                                                                                         |
|----------------------------------|-------------------------------------------------------------------------------|-------------------------|---------------|-----------|-----------------------------------------------------------------------------------------------|
| env                              | environment/stage                                                             | dev, uat, qa, stg, prod | String        | Yes       |                                                                                               |
| api_source_code_version          | version of api to deploy, should be a git reference                           |                         | String        | Yes       | this should correspond to a docker image tag that exists at wherver the `docker_image_uri` is |
| vpc_name                         | name of vpc                                                                   |                         | String        | Yes       |                                                                                               |
| docker_image_uri                 | URI of the docker image repo                                                  |                         | String        | Yes       |                                                                                               |
| td_cpu                           | allocated vCPU - example: 1024 or '1 vCPU' or '1 vcpu'                        |                         | Int or String | No        | defaults to 1024                                                                              |
| td_memory                        | allocated memory - example: 2048 or '2GB' or '2 GB'                           |                         | Int or String | No        | defaults to 2048                                                                              |
| desired_count                    | number of application containers to start                                     |                         | Int           | No        | defaults to 2                                                                                 |
| service                          | name of the service                                                           |                         | String        | No        | defaults to 'restaurant-search'                                                               |
| es_domain_name_suffix            | suffix for the OpenSearch domain name                                         |                         | String        | No        |                                                                                               |

### Lessons Learned

### References
