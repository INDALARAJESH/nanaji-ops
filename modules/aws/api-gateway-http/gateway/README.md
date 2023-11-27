# Create HTTP API Gateway

### General

* Description: A module to create an HTTP API Gateway
* Created By: Sebastien Plisson
* Module Dependencies: `` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x
* Creates: `aws_apigatewayv2_api` and `aws_apigatewayv2_stage` resources.

![aws-api-gateway-http-gateway](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-http-gateway/badge.svg)

### Usage

* Terraform:

* HTTP Api Gateway example
```hcl
module "http_api_gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-http/gateway?ref=aws-api-gateway-http-gateway-v2.0.1"

  env  = "qa"
  name = "test"
  access_log_settings = [
    {
    destination_arn = "log-group-arn"

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
  ]

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                   | Options |  Type       | Required? | Notes |
| :------------------ | :---------------------------- | :------ | :----:      | :-------: | :---- |
| name                | name of api gateway           |         | string      |    Yes    |       |
| env                 | unique environment       name |         | string      |    Yes    | N/A   |
| env_inst            | environment instance number   | 1...n   | string      |    No     | N/A   |
| access_log_settings | cloudwatch log settings       |         | object list |    No     | N/A   |

#### Outputs

| Variable Name | Description                                      | Type   | Notes |
| :------------ | :---------------------------                     | :----: | :----:|
| api_id        | id of `aws_apigatewayv2_api resource`            | string |       |
| stage_id      | id of default `aws_apigatewayv2_stage` resource  | string |       |
| api_id        | arn of default `aws_apigatewayv2_stage` resource | string |       |

### Lessons Learned

### References
