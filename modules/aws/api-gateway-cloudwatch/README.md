# Create role and policy to allow API Gateway to write Cloudwatch logs

### General

* Description: A module to create role and policy to allow API Gateway to write Cloudwatch logs
* Created By: Sebastien Plisson
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-cloudwatch](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-cloudwatch/badge.svg)

### Usage

* Terraform:

* Example
```hcl
module "cloudwatch" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/api-gateway-cloudwatch?ref=aws-api-gateway-cloudwatch-v2.0.0"

  env        = "dev"
  create_iam = 1
}
```

### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name | Description                     | Options |  Type  | Required? | Notes |
| :------------ | :------------------------------ | :------ | :----: | :-------: | :---- |
| env           | unique environment       name   |         | string |    Yes    | N/A   |
| create_iam    | 1 to create IAM role and policy | default: 0     |  int   |    No     | N/A   |

#### Outputs

### Lessons Learned

### References
