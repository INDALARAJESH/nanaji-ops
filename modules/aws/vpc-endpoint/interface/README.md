# Interface VPC Endpoint

A VPC endpoint enables you to securely connect your VPC to another service.

There are three types of VPC endpoints – Interface endpoints, Gateway Load Balancer endpoints, and gateway endpoints.

Interface endpoints and Gateway Load Balancer endpoints are powered by AWS PrivateLink, and use an elastic network interface (ENI) as an entry point for traffic destined to the service.

Interface endpoints are typically accessed using the public or private DNS name associated with the service, while gateway endpoints and Gateway Load Balancer endpoints serve as a target for a route in your route table for traffic destined for the service.

Currently, written with the following services in mind:

- API Gateway

### General

* Description: AWS Interface VPC Endpoint Module
* Created By: Karol Kania
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x


![aws-vpce-interface](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpce-interface/badge.svg)

# TODO
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
* [AWS Docs - API Gateway Private API](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html)