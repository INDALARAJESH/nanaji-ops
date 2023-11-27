# Restaurant Search Manage

### General

* Description: Task definition for running managing index migrations
* Created By: MJ Hardin
* Module Dependencies: `aws_vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-restaurant-search-db](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-restaurant-search-manage/badge.svg)


### Usage

* Terraform (base module deployment):

```hcl
module "restaurant_search_manage" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/restaurant-search/manage?ref=restaurant-search-manage-v2.0.4"

  env                     = "dev"
  vpc_name                = "nc-dev"
  api_source_code_version = "main"
  docker_image_uri        = "449190145484.dkr.ecr.us-east-1.amazonaws.com/restaurant-search-api"
}
```

## Module Options

### Inputs

| Variable Name                    | Description                                                                   | Options                 | Type    | Required? | Notes                                                            |
|----------------------------------|-------------------------------------------------------------------------------|-------------------------|---------|-----------|------------------------------------------------------------------|
| env                              | unique environment/stage namestage                                            | dev, uat, qa, stg, prod | String  | Yes       |                                                                  |
| vpc_name                         | name of vpc                                                                   |                         | String  | Yes       |                                                                  |
| api_source_code_version          | git branch or SHA                                                             |                         | Boolean | No        | this value will be overwritten downstream outside the tf context |
| docker_image_uri                 | URI to the docker image                                                       |                         | String  | No        | this should be an ECR repo                                       |
| replica_db_name                  | name of the database to connect to in the ETL process                         |                         |         |           |                                                                  |
| es_domain_name_suffix            | suffix for the OpenSearch domain name                                         |                         | String  | No        |                                                                  |

### Lessons Learned

### References
