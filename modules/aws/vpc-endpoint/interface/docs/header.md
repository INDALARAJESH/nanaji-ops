# Interface VPC Endpoint

A VPC endpoint enables you to securely connect your VPC to another service.

There are three types of VPC endpoints – Interface endpoints, Gateway Load Balancer endpoints, and gateway endpoints.

Interface endpoints and Gateway Load Balancer endpoints are powered by AWS PrivateLink, and use an elastic network interface (ENI) as an entry point for traffic destined to the service.

Interface endpoints are typically accessed using the public or private DNS name associated with the service, while gateway endpoints and Gateway Load Balancer endpoints serve as a target for a route in your route table for traffic destined for the service.

[AWS services that integrate with AWS PrivateLink](https://docs.aws.amazon.com/vpc/latest/privatelink/integrated-services-vpce-list.html)

![aws-vpce-interface](https://github.com/ChowNow/ops-tf-modules/workflows/aws-vpce-interface/badge.svg)

## General

* Description: AWS Interface VPC Endpoint Module
* Created By: Karol Kania
* Module Dependencies: `vpc`
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x
