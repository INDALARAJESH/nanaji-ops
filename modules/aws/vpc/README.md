# AWS VPC

### General

* Description: AWS VPC Module
* Created By: Joe Perez
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-vpc](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpc/badge.svg)


### Usage

* Terraform:


`ops>terraform>environments>uat>core>vpc>vpc.tf`
```hcl
module "ab_vpc" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc?ref=aws-vpc-v2.1.6"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  cidr_block      = "10.21.0.0/16"
  env             = var.env
  private_subnets = ["10.21.0.0/19", "10.21.32.0/19", "10.21.64.0/19"]
  public_subnets  = ["10.21.96.0/20", "10.21.128.0/20", "10.21.160.0/20"]
  vpc_name_prefix = "ab"

  ### optional
  extra_allowed_subnets = ["${data.aws_eip.primary_vpc_ngw.public_ip}/32"]
}
```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name       | Description                                | Options                            |  Type  | Required? | Notes |
| :------------------ | :----------------------------------------- | :--------------------------------- | :----: | :-------: | :---- |
| azs                 | which Availability Zones to use            | depends on region                  |  list  |    Yes    | N/A   |
| cidr_block          | the CIDR block to use for the VPC          | Please use a /16                   | string |    Yes    | N/A   |
| enable_zone_private | boolean to enable/disable private dns zone | 1/0 (default: 1)                   |  int   |    No     | N/A   |
| env                 | unique environment/stage name              | sandbox/dev/qa/uat/stg/prod/etc    | string |    Yes    | N/A   |
| privatelink_subnets | privatelink CIDR block list                |                                    |  list  |    No     | N/A   |
| private_subnets     | list of private subnets for VPC            | use at least a /19 for each subnet | string |    Yes    | N/A   |
| public_subnets      | list of public subnets for VPC             | use at least a /20 for each subnet | string |    Yes    | N/A   |
| vpc_name_prefix     | vpc name prefix                            | nc                                 | string |    Yes    | N/A   |

#### Outputs

| Variable Name      | Description                                                                             |     Type     | Notes |
| :----------------- | :-------------------------------------------------------------------------------------- | :----------: | :---- |
| private_gateway_id | gateway id for default route attached to private subnet rtb. usually a nat gateway      |    string    |       |
| private_rtb_id     | gateway id for default route attacehd to public subnet rtb. usually an internet gateway |    string    |       |
| private_subnet_ids | list of private subnet id                                                               | list(string) |       |
| public_gateway_id  | list of public subnet id                                                                | list(string) |       |
| public_rtb_id      | route table attached to public subnets                                                  |    string    |       |
| public_subnet_ids  | route table attached to private subnets                                                 |    string    |       |
| vpc_id             | VPC ID of this VPC                                                                      |    string    | N/A   |


### Lessons Learned

* Tagging is super important at this level, it will set the tone for other modules to perform data source lookups on subnets, subnet ids, vpc name, etc.

### References

* [Practical VPC Design](https://medium.com/aws-activate-startup-blog/practical-vpc-design-8412e1a18dcc)
