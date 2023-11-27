# Gateway VPC Endpoint

A gateway endpoint is a gateway that you specify as a target for a route in your route table for traffic destined to a supported AWS service. As of the time of writing, the following AWS services are supported:

- Amazon S3
- DynamoDB

### General

* Description: AWS Gateway VPC Endpoint Module
* Created By: Tim Ho
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-vpce-gateway](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpce-gateway/badge.svg)

### Usage

* Terraform:

```hcl
module "vpc_primary" {
  source = "git::git@github.com:ChowNow/ops-tf-modules.git//modules/aws/vpc-endpoint/gateway?ref=aws-vpce-gateway-v2.0.0"

  env          = var.env
  service_name = "s3"
  vpc_tag_name = "main-${var.env}"
}

```


### Options

* Description: Input variable options and Outputs for other modules to consume

#### Inputs

| Variable Name              | Description                              | Options                                                    | Type     | Required? | Notes |
| :------------------------- | :--------------------------------------- | :--------------------------------------------------------- | :------: | :-------: | :---- |
| env                        | unique environment/stage name            | sandbox/dev/qa/uat/stg/prod/etc                            | string   |  Yes      | N/A   |
| env_inst                   | environment instance count               | 00, 01, etc                                                | string   |  No       | N/A   |
| endpoint_policy            | JSON endpoint policy                     | valid vpc endpoint policy (default: allow all access)      | string   |  No       | N/A   |
| service_name               | service the endpoint connects to         | aws-supported service                                      | string   |  Yes      | N/A   |
| vpc_tag_name               | vpc tag:Name for endpoint to be created  | valid vpc name                                             | string   |  Yes      | N/A   |
| vpce_route_tables          | route table ids to connect to endpoint   | valid route table ids (default: all route tables in vpc)   | string   |  No       | N/A   |


#### Outputs

| Variable Name      | Description         | Type    | Notes |
| :----------------- | :------------------ | :-----: | :---- |
| vpce_id            | vpc endpoint id     | string  | N/A   |


### References

* [AWS Docs](https://docs.aws.amazon.com/vpc/latest/userguide/vpce-gateway.html)
