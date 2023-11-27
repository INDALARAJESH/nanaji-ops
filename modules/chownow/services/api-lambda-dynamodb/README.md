# Create service with a lambda behind a HTTP API Gateway and a DynamoDB table

### General

* Description: A module to create service with a lambda behind a HTTP API Gateway and a DynamoDB table
* Created By: Sebastien Plisson
* Module Dependencies:
  * `aws/lambda/basic`
  * `aws/dynamodb`
  * `aws/api-gateway/http`
  * `aws/api-gateway/lambda-integration` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-api-lambda-dynamodb](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-api-lambda-dynamodb/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "api-lambda-dynamodb" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/api-lambda-dynamodb?ref=api-lambda-dynamodb-v2.0.1"

  env                = "dev"
  name               = "facebook"
  service            = "integration"
  api_id             = "id"
  lambda_description = "This lambda does magic"
  lambda_runtime     = "nodejs12.x"
  hash_key           = "restaurant_id"
  attribute_list     = []
  billing_mode       = "PAY_PER_REQUEST"
  path_prefix        = "/fbe"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name          | Description                                                      | Options               |    Type     | Required? | Notes |
| :--------------------- | :--------------------------------------------------------------- | :-------------------- | :---------: | :-------: | :---- |
| name                   | name                                                             |                       |   string    |    Yes    |       |
| service                | name of service used in combination with name to name the lambda |                       |   string    |    Yes    |       |
| api_id                 | REST API gateway id                                              |                       |   string    |    Yes    |       |
| lambda_runtime         | lambda runtime                                                   |                       |   string    |    Yes    |       |
| lambda_description     | lambda description                                               |                       |   string    |    No     |       |
| lambda_env_variables   | lambda environment variables                                     |                       | map(string) |    No     |       |
| access_log_settings    | cloudwatch log settings                                          |                       |   object    |    No     | N/A   |
| path_prefix            | HTTP path prefix                                                 |                       |   string    |    No     | ""    |
| table_name             |                                                                  |                       |   string    |    Yes    |       |
| hash_key               |                                                                  |                       |   string    |    Yes    |       |
| attribute_list         |                                                                  |                       |    list     |    Yes    |       |
| billing_mode           |                                                                  | Default: PROVISIONNED |   string    |    No     |       |
| write_capacity         |                                                                  | Default: 20           |   string    |    No     |       |
| read_capacity          |                                                                  | Default: 20           |   string    |    No     |       |
| global_secondary_index | secondary index attributes                                       |                       |    list     |    No     |       |
| env                    | unique environment name                                          |                       |   string    |    Yes    | N/A   |
| env_inst               | environment instance number                                      | 1...n                 |   string    |    No     | N/A   |

#### Outputs

### Lessons Learned

### References
