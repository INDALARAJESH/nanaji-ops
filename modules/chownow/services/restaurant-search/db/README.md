# Restaurant Search DB

### General

* Description: Stack for running restaurant search service persistence layer
* Created By: MJ Hardin
* Module Dependencies: `aws_vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-db](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-db/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "restaurant_search_db" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/db?ref=restaurant-search-db-v2.0.0"

  env            = "dev"
  vpc_name       = "main-dev"
}
```

## Module Options

### Inputs

| Variable Name                  | Description                                                              | Options                 | Type    | Required? | Notes                                                |
|:-------------------------------|:-------------------------------------------------------------------------|-------------------------|---------|-----------|------------------------------------------------------|
| env                            | unique environment/stage namestage                                       | dev, uat, qa, stg, prod | String  | Yes       |                                                      |
| env_inst                       | instance of this environment                                             | 00, 01, 02, etc.        | String  | No        | defaults to ""                                       |
| vpc_name                       | name of vpc                                                              |                         | String  | Yes       |                                                      |
| create_iam_service_linked_role | controls whether the service linked role for es.amazonaws.com is created |                         | Boolean | No        | defaults to false                                    |
| instance_type                  | ec2 instance type created for search db nodes                            |                         | String  | No        | defaults to "t2.medium.elasticsearch"                |
| instance_count                 | number of search db nodes to create                                      |                         | Int     | No        | defaults to 3 -- must match number of subnets in VPC |
| service                        | name of the service                                                      |                         | String  | No        | defaults to 'restaurant-search'                      |
| dedicated_master_type          | ec2 instance type create for each dedicated master node                  |                         |         |           |                                                      |
| dedicated_master_count         | number of dedicated master nodes                                         |                         |         |           |                                                      |
| dedicated_master_enabled       | bool representing whether dedicated master nodes should be used          |                         |         |           |                                                      |


### Outputs 

| Variable Name   | Description                                 | Type   | Notes |
| --------------- | ------------------------------------------- | ------ | ----- |
| search_endpoint | URL that search database can be accessed at | string |       |
| kibana_endpoint | URL that Kibana can be accessed at          | string |       |
| user_id         | AWS access key ID for OpenSearch user       | string |       |
| user_secret     | AWS secret access key for OpenSearch user   | string |       |

### Lessons Learned

### References
