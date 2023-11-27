# AWS VPC Endpoints - Legacy

### General

* Description: AWS VPC Endpoint Module for legacy VPC deployments
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-vpce-legacy](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpce-legacy/badge.svg)


### Usage

* Terraform:


`ops>terraform>environments>uat>core>vpc>vpc_endpoint.tf`
```hcl
module "ab_vpc" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/legacy?ref=aws-vpce-legacy-v2.0.0"

  enable_vpce_aws     = 1
  enable_vpce_datadog = 1
  env                 = var.env
  vpc_name            = var.env

}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                               | Options             |  Type  | Required? | Notes |
| :------------------ | :---------------------------------------- | :------------------ | :----: | :-------: | :---- |
| enable_vpce_aws     | enables several AWS service VPC endpoints | 0 or 1 (default: 0) |  int   |    No     | N/A   |
| enable_vpce_datadog | enables several datadog VPC endpoints     | 0 or 1 (default: 0) |  int   |    No     | N/A   |
| env                 | unique/short environment name             |                     | String |    Yes    | N/A   |
| env_inst            | iteration of environment                  | 00, 01, 02, etc     | String |    No     | N/A   |
| vpc_name            | vpc name                                  |                     | string |    Yes    | N/A   |

#### Outputs

| Variable Name | Description | Type  | Notes |
| :------------ | :---------- | :---: | :---- |



### Lessons Learned


### References
