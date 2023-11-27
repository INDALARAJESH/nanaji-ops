# Create an integration between an API Gateway and a lambda function

### General

* Description: A module to create an integration between an API Gateway and a lambda function
* Created By: Sebastien Plisson
* Module Dependencies: `` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x
* Creates: `aws_apigatewayv2_integration`, `aws_apigatewayv2_route` (optional), `aws_lambda_permission`

![aws-api-gateway-lambda-integration](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-lambda-integration/badge.svg)

### Usage

* Terraform:

* HTTP Api Gateway example
```hcl
module "api_gateway_lambda_integration" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-http/lambda-integration?ref=aws-api-gateway-http-lambda-integration-v2.0.0"

  api_id            = "id"
  lambda_arn        = "arn"
  lambda_invoke_arn = "invoke arn"
  path_prefix       = "/fbe"
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                   | Options                     | Type   | Required? | Default   | Notes |
| :------------ | :---------------------------  | :-------------------------- | :----: | :-------: | :----:    | :----:
| api_id                      | api gateway id           |                    | string |  Yes      | N/A         |
| lambda_arn                  | arn of lambda to invoke  |                    | string |  Yes      | N/A      |
| lambda_invoke_arn           | invoke arn of lambda to invoke |              | string |  Yes      | N/A      |
| enable_default_route        | enable default route     |                    | int    |  No       | 1        |
| path_prefix                 | HTTP path prefix         |                    | string |  No       | ""       |
| payload_format_version      | Version of API format    |                    | string |  No       | "2.0"    | [Format Reference](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html#http-api-develop-integrations-lambda.proxy-format)
| source_arn_permission_path  | Path for lambda execution permission    |     | string |  No       | "/\*/\*/*" | Only necessary in some cases when not using the default route. Example: /\*/\*

#### Outputs
| Variable Name | Description                                   | Type   | Notes |
| :------------ | :---------------------------                  | :----: | :----:|
| id            | id of `aws_apigatewayv2_integration` resource | string |       |

### Lessons Learned

### References
