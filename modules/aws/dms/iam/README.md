# AWS Database Migration Service IAM Module

### General

* Description: A module to create the required AWS DMS role to see CloudWatch logs
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-dms-iam](https://github.com/ChowNow/ops-tf-modules/workflows/aws-dms-iam/badge.svg)

### Usage

#### Terraform
* Terraform:

```hcl

module "aws_dms_iam" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/dms/iam?ref=aws-dms-iam-v2.0.0"

  env = var.env

}

```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name        | Description                                            | Options         | Type   | Required? | Notes |
| :------------------- | :----------------------------------------------------  | :-------------- | :----: | :-------: | :---- |
| env                  | unique environment/stage name                          |                 | string |  Yes      | N/A   |
| env_inst             | environment instance number                            | 1...n           | string |  No       | N/A   |

#### Outputs




### Lessons Learned

* You need these IAM roles policies set with these exact names for each AWS Account

### Resources

* [Why can't I see CloudWatch logs for an AWS DMS task?](https://aws.amazon.com/premiumsupport/knowledge-center/dms-cloudwatch-logs-not-appearing/)
