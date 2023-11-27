# Terraform REST API Gateway - Private - built using Swagger / OpenAPI spec

## General

* Description: A module to create a Private REST API Gateway using Swagger / OpenAPI spec
* Created By: Sebastien Plisson, Karol Kania
* Module Dependencies: `vpc-endpoint/interface` 
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

![aws-api-gateway-rest-gateway-private-openapi](https://github.com/ChowNow/ops-tf-modules/workflows/aws-api-gateway-rest-gateway-private-openapi/badge.svg)

## VPC Endpoint Interface(s)

Create an interface VPC endpoint for API Gateway and associate it with your Private API Gateway.

The API Gateway component service for API execution is called `execute-api`. To access your private API once it's deployed, you need to create an interface VPC endpoint for it in your VPC.

After you've created your VPC endpoint, you can use it to access multiple private APIs. 

In order to use it, one should associate a VPC endpoint with a private REST API.

Assuming you want to interconnect two different VPCs (so the traffic doesn't leave the AWS network), you should operate on the VPC Endpoints level. 

In order to properly set up and secure the Private API Gateway between two interconnected VPCs:

 - create the VPC Endpoint interface and associate it with the Private API Gateway in `VPC-A`
 - create the VPC Endpoint interface in `VPC-B`
 - restrict access to VPC Endpoint from `VPC-B` in resource policy on Private API Gateway in `VPC-A` -- see below

## NOTE for API GW Resource Policy

Resource Policy is **REQUIRED** for `PRIVATE` Api Gateway

***Important***

To restrict access to specific VPC endpoints, you must include `aws:SourceVpce` conditions in your API's resource policy.
If your policy does not include any of these conditions, your API will be accessible by all VPCs.

The module is predefined with the resource policy filtering the incoming traffic to drop all the traffic unless it's coming from the provided `source_vpc_endpoint_ids`
