# Create service with a lambda behind a REST API Gateway

### General

* Description: A module to create service with a lambda behind a REST API Gateway
* Created By: Sebastien Plisson
* Module Dependencies:
  * `aws/lambda/basic`
  * `aws/api-gateway-rest/gateway`
  * `aws/api-gateway-rest/lambda-integration` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![chownow-services-rest-api-lambda](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-rest-api-lambda/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "rest-api-lambda" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/chownow/services/rest-api-lambda?ref=rest-api-lambda-v2.0.1"

  env                = "dev"
  name               = "test"
  api_gateway_name   = "channels"
  lambda_description = "This lambda does magic"
  lambda_runtime     = "nodejs12.x"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                                                      | Options        |    Type     | Required? | Notes |
| :------------------- | :--------------------------------------------------------------- | :------------- | :---------: | :-------: | :---- |
| name                 | name of api gateway                                              |                |   string    |    Yes    |       |
| service              | name of service used in combination with name to name the lambda |                |   string    |    Yes    |       |
| api_gateway_name     | api gateway name                                                 |                |   string    |    Yes    |       |
| domain_names         | list of custom domain names to map to stage and api              |                |    list     |    No     |       |
| lambda_runtime       | lambda runtime                                                   |                |   string    |    Yes    |       |
| lambda_description   | lambda description                                               |                |   string    |    No     |       |
| lambda_env_variables | lambda environment variables                                     |                | map(string) |    No     |       |
| lambda_s3            | lambda uses s3                                                   | default: true  |    bool     |    No     | N/A   |
| lambda_ecr           | lambda uses ecr                                                  | default: false |    bool     |    No     | N/A   |
| lambda_image_uri     | lambda docker image uri                                          |                |   string    |    No     | N/A   |
| access_log_settings  | cloudwatch log settings                                          |                |   object    |    No     | N/A   |
| path_prefix          | HTTP path prefix                                                 |                |   string    |    Yes    | ""    |
| access_log_settings  | cloudwatch log settings                                          |                |   object    |    No     | N/A   |
| env                  | unique environment       name                                    |                |   string    |    Yes    | N/A   |
| env_inst             | environment instance number                                      | 1...n          |   string    |    No     | N/A   |


#### Outputs

### Lessons Learned

### References
