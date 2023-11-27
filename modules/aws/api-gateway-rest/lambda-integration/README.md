# Create an integration between an API Gateway and a lambda function

### General

* Description: A module to create an integration between an API Gateway and a lambda function
* Created By: Sebastien Plisson
* Module Dependencies: `` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-rest-lambda-integration](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-lambda-integration/badge.svg)

### Usage

* Terraform:

* HTTP Api Gateway example
```hcl
module "api_gateway_lambda_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/lambda-integration?ref=aws-api-gateway-rest-lambda-integration-v2.0.0"

  env               = "dev"
  api_gateway_name  = "channels"
  lambda_arn        = "arn"
  lambda_invoke_arn = "invoke arn"
  path_prefix       = "fbe"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                     | Options |  Type  | Required? / Default | Notes |
| :------------------ | :------------------------------ | :------ | :----: | :-----------------: | :---- |
| env                 | unique environment       name   |         | string |         Yes         | N/A   |
| env_inst            | environment instance number     | 1...n   | string |         No          | N/A   |
| api_gateway_name    | api gateway name                |         | string |         Yes         |       |
| lambda_arn          | arn of lambda to invoke         |         | string |         Yes         | N/A   |
| lambda_invoke_arn   | imnvoke arn of lambda to invoke |         | string |         Yes         | N/A   |
| path_prefix         | HTTP path prefix                |         | string |         No          | ""    |
| access_log_settings | cloudwatch log settings         |         | object |         No          | N/A   |

#### Outputs

### Lessons Learned

### References
