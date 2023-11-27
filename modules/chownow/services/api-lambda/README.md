# Create service with a lambda behind a HTTP API Gateway

### General

* Description: A module to create service with a lambda behind a HTTP API Gateway
* Created By: Sebastien Plisson
* Module Dependencies:
  * `aws/lambda/basic`
  * `aws/api-gateway/lambda-integration` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-api-lambda](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-api-lambda/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "api-lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/api-lambda?ref=api-lambda-v2.0.2"

  env                = "dev"
  name               = "test"
  api_id             = "id"
  lambda_description = "This lambda does magic"
  lambda_runtime     = "nodejs12.x"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                                                      | Options |    Type     | Required? | Notes |
| :------------------- | :--------------------------------------------------------------- | :------ | :---------: | :-------: | :---- |
| name                 | name                                                             |         |   string    |    Yes    |       |
| service              | name of service used in combination with name to name the lambda |         |   string    |    Yes    |       |
| api_id               | REST API gateway id                                              |         |   string    |    Yes    |       |
| lambda_runtime       | lambda runtime                                                   |         |   string    |    Yes    |       |
| lambda_description   | lambda description                                               |         |   string    |    No     |       |
| lambda_env_variables | lambda environment variables                                     |         | map(string) |    No     |       |
| access_log_settings  | cloudwatch log settings                                          |         |   object    |    No     | N/A   |
| path_prefix          | HTTP path prefix                                                 |         |   string    |    No     | ""    |
| env                  | unique environment       name                                    |         |   string    |    Yes    | N/A   |
| env_inst             | environment instance number                                      | 1...n   |   string    |    No     | N/A   |


#### Outputs

### Lessons Learned

### References
