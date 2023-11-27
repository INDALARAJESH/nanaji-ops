# Create REST API Gateway

### General

* Description: A module to create an REST API Gateway
* Created By: Sebastien Plisson
* Module Dependencies: `` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-rest-gateway](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-gateway/badge.svg)

### Usage

* Terraform:

* REST Api Gateway example
```hcl
module "rest_api_gateway" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-rest/gateway?ref=aws-api-gateway-rest-gateway-v2.0.0"

  env           = "qa"
  name = "test"

}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                   | Options |  Type  | Required? | Notes |
| :------------------ | :---------------------------- | :------ | :----: | :-------: | :---- |
| name                | name of api gateway           |         | string |    Yes    |       |
| env                 | unique environment       name |         | string |    Yes    | N/A   |
| env_inst            | environment instance number   | 1...n   | string |    No     | N/A   |

#### Outputs

### Lessons Learned

### References
